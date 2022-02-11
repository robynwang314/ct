module Api
  module V1
    class CountriesController < ApplicationController
      include HTTParty
      require 'json'

      attr_accessor :name, :country, :alpha2, :alpha3, :parse_page, :parse_country, :paragraphsection_exists

      def index
        countries = ISO3166::Country.find_all_countries_by_region('Europe')
        render json: countries.as_json

        # countries = Country.all
        # render json: CountrySerializer.new(countries, options).serialized_json
      end

      def country_codes(name)
        # using the name, find the necessary country codes
        @country = ISO3166::Country.find_country_by_name(name.titleize)
        @alpha2 = country.alpha2
        @alpha3 = country.alpha3
      end

      def embassy_information
        name = name_params
        country_codes(name)

         # get list of all countries from embassy's travel advisory site
        document = HTTParty.get("https://travel.state.gov/content/travel/en/traveladvisories/COVID-19-Country-Specific-Information.html")
        @parse_page ||= Nokogiri::HTML(document)

        # get travel advisory for a specific country
        specific_country = HTTParty.get(get_country_embassy_link(name.titleize))
        @parse_country ||= Nokogiri::HTML(specific_country)

        # scrape and build information 
        @country_info_from_embassy = build_country_info

        response =  {:country_info_from_embassy => @country_info_from_embassy}
        render json: response
      end

      def owid_stats
        country_codes(name_params)

        # get country statistics from OWID
        all_countries_data = Country.get_all_our_world_in_data
        @country_stats = all_countries_data[alpha3]

        response =  {:stats => @country_stats}
        render json: response
      end

      def travel_advisory
        country_codes(name_params)

        @travel_advisory = Country.get_travel_advisory(alpha2)
        response =  @travel_advisory
        render json: response
      end

      def reopenEU
        country_codes(name_params)

         # country information from reOpenEu
        json_visa = JSON.parse(Country.get_all_reopenEU_data) 
        all_country_info = json_visa.select { |country| country["nutscode"] == alpha3 }
        get_domain = all_country_info[0]["indicators"].select {|data| data["comment"] != ""}     
    
        # build relevant information from reOpenEu into object
        all_comments_list = []
        get_domain.each_with_object({}) do |c| 
          comment = { }
          comment["domain_id"] =  c["domain_id"]
          comment["domain_name"] = c["domain_name"]
          comment["indicator_id"] = c["indicator_id"]
          comment["indicator_name"] = c["indicator_name"]
          comment["comment"] = c["comment"]
          comment["value"] = c["value"]

          all_comments_list << comment
        end
        
        # group reOpenEu data by domain_name
        @sorted_comments_list = all_comments_list.group_by { |d| d["domain_name"] }
        
        response =  {:comments => @sorted_comments_list}
        render json: response
      end

      # def show
      #   # get the selected country name
      #   @name = name_params

      #   country_codes(name)
      #   embassy_information
      #   owid_stats
      #   travel_advisory
      #   reopenEU
     
      #   # puts JSON.pretty_generate(@sorted_comments_list) 

      #   # create new object containing all of above info
      #   response = {:stats => @country_stats, :travel_advisory => @travel_advisory, :country_info_from_embassy => @country_info_from_embassy, :comments => @sorted_comments_list }

      #   # return as json
      #   render json: response

      #   # country = Country.find_by(slug: params[:slug])
      #   # render json: CountrySerializer.new(country, options).serialized_json
      # end

      private

      def name_params
        params.require(:name)
      end

      def get_country_embassy_link(name)
        str_name = name.to_s
        parse_page.css("a:contains('#{str_name}')").first['href']
      end

      def transform_entry_content_to_text(all_content)
        text_content = []
        all_content.text.strip!.each_line do |content|
          text_content << content
        end
        text_content
      end

      def transform_paragraphsections_to_text(all_content)
        text_content = []
          all_content.each do |content|
          text_content << content.text.gsub("By U.S. Mission Germany", "").strip!
        end
        text_content
      end

      def all_content
        entry_content = parse_country.at_css(".entry-content") 
        main = parse_country.at_css(".main") 
        main_content_wrapper = parse_country.at_css(".main-content-wrapper")
        
        all_content_text = []

        if entry_content
          all_content_text = transform_entry_content_to_text(entry_content)
        elsif main
          all_content_text = transform_entry_content_to_text(main)
        elsif main_content_wrapper
          @paragraphsection_exists = !main_content_wrapper.css(".paragraphsection").empty?
          
          if paragraphsection_exists
            all_content = main_content_wrapper.css(".paragraphsection")
          else
            all_content = main_content_wrapper
          end
          all_content_text = transform_paragraphsections_to_text(all_content)
        end
        all_content_text
      end

      def section_indexes(all_content_text)
        information_sections = Country::INFORMATION_SECTIONS
        sub_section_keys = Country::SUB_SECTIONS
        indices = {}

        information_sections.each_with_index do |section, array_index|
          if array_index == 0 && paragraphsection_exists
            section_index = all_content_text.index { |x| x.titleize.include? ("Country-Specific Information").titleize }
          elsif array_index == 0
            section_index = all_content_text.index { |x| x.titleize.include? ("Country-Specific Information").titleize } + 1 
          else
            section_indice = all_content_text.each_index.select{|i| all_content_text[i].gsub(/[^\001-\176]+/, "").titleize.include? (section).titleize }
            section_index = section_indice.find {|x| x > indices[information_sections[array_index-1]]} unless information_sections[array_index-1].nil?
            if information_sections[array_index-1].nil?
              section_index = section_indice.find {|x| x > indices[information_sections[array_index-2]]}
            end

            if paragraphsection_exists || !(sub_section_keys.include? section)
              section_index
            else 
              section_index += 1
            end
            section_index
          end
          indices[section] = section_index
        end        
        indices
      end

      def build_country_info
        all_content_text = all_content
        main_section_index = section_indexes(all_content_text)

        important_info = []
        country_specific = []
        testing_vaccine = []
        entry_exit = []
        local_resources = []
        other_links = []
        misc = []
       
        all_content_text.each_with_index{|x, i| 
          case i
          # important inforamtion section
          when 0...(main_section_index["Country-Specific Information"])
            important_info << x
          # country specific section
          when (main_section_index["Country-Specific Information"])...(main_section_index["COVID-19 Testing"]) 
            country_specific << x
          # not addiing +1 because need header
          when (main_section_index["COVID-19 Testing"])...(main_section_index["Entry and Exit Requirements"])
            testing_vaccine << x
          when (main_section_index["Entry and Exit Requirements"])...(main_section_index["Movement Restrictions"])
            entry_exit << x
          when (main_section_index["Local Resources"])...(main_section_index["Other Links"])
            local_resources << x
          when (main_section_index["Other Links"])..(all_content_text.size - 3)
            other_links << x
          else
            if !(main_section_index.keys.include? i)
              misc << x
            end
          end
        }

        all_embassy_info = {}

        all_embassy_info["important_info"] = important_info.join('') 
        all_embassy_info["country_specific"] = country_specific.join('') 
        all_embassy_info["testing_vaccine"] = testing_vaccine.join('') 
        all_embassy_info["entry_exit"] = entry_exit.join('')  
        all_embassy_info["local_resources"] = local_resources.join('') 
        all_embassy_info["other_links"] = other_links.join('')  
        all_embassy_info["misc"] = misc.join('')  
 
        all_embassy_info
      end
    end
  end
end
