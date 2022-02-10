module Api
  module V1
    class CountriesController < ApplicationController
      include HTTParty
      require 'json'

      attr_accessor :parse_page, :parse_country, :name

      def index
        countries = ISO3166::Country.find_all_countries_by_region('Europe')
        render json: countries.as_json

        # countries = Country.all
        # render json: CountrySerializer.new(countries, options).serialized_json
      end

      def show
        # get the selected country name
        name = params[:name]

        # using the name, find the necessary country codes
        c = ISO3166::Country.find_country_by_name(name.titleize)
        alpha2 = c.alpha2
        alpha3 = c.alpha3

        # get list of all countries from embassy's travel advisory site
        doc = HTTParty.get("https://travel.state.gov/content/travel/en/traveladvisories/COVID-19-Country-Specific-Information.html")
        @parse_page ||= Nokogiri::HTML(doc)

        # get travel advisory for a specific country
        specific_country = HTTParty.get(get_country_embassy_link(name.titleize))
        @parse_country ||= Nokogiri::HTML(specific_country)

        # scrape and build information 
        @country_info_from_embassy = build_country_info

        # get country statistics from OWID
        all_countries_data = Country.get_all_our_world_in_data
        @country_stats = all_countries_data[alpha3]

        # get travel alert status
        @travel_advisory = Country.get_travel_advisory(alpha2)
       
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
        # puts JSON.pretty_generate(@sorted_comments_list) 

        # create new object containing all of above info
        response = {:stats => @country_stats, :travel_advisory => @travel_advisory, :country_info_from_embassy => @country_info_from_embassy, :comments => @sorted_comments_list }

        # return as json
        render json: response

        # country = Country.find_by(slug: params[:slug])
        # render json: CountrySerializer.new(country, options).serialized_json
      end

      private

      def get_country_embassy_link(name)
        str_name = name.to_s
        parse_page.css("a:contains('#{str_name}')").first['href']
      end

      def transform_entry_content_to_text(all_content)
        lines_of_text = []
        all_content.text.strip!.each_line do |content|
          lines_of_text << content
        end
        lines_of_text
      end

      def transform_paragraphsections_to_text(all_content)
        lines_of_text = []
          all_content.each do |content|
          lines_of_text << content.text.strip!
        end
        lines_of_text
      end

      def build_country_info
        entry_content = parse_country.at_css(".entry-content") 
        main = parse_country.at_css(".main") 
        main_content_wrapper = parse_country.at_css(".main-content-wrapper")
        
        if entry_content
          all_content = entry_content
        elsif main
          all_content = main
        elsif main_content_wrapper
          paragraphsection = main_content_wrapper.css(".paragraphsection")
          if paragraphsection
            all_content = paragraphsection
          else
            all_content = main_content_wrapper
          end
          all_content
        end
        
        all_embassy_info = {}
        lines_of_text = []
        important_info = []
        country_specific = []
        testing_vaccine = []
        entry_exit = []
        movement_restrictions = [] 
        quarantine = []
        transportation = []
        fines = []
        consular_operations = []
        local_resources = []
        other_links = []
        misc = []
        
        if entry_content || main
          lines_of_text = transform_entry_content_to_text(all_content)
        end

        if main_content_wrapper && paragraphsection 
          lines_of_text = transform_paragraphsections_to_text(all_content)
        end

        country_specific_index = lines_of_text.index { |x| x.titleize.include? ("Country-Specific Information").titleize }
        testing_index = lines_of_text.index { |x| x.titleize.include? ("COVID-19 Testing").titleize }
        vaccine_index = lines_of_text.index { |x| x.titleize.include? ("COVID-19 Vaccine").titleize }
        entry_exit_requirements_index = lines_of_text.index { |x| x.titleize.include? ("Entry and Exit Requirements").titleize }
        movement_index = lines_of_text.index { |x| x.titleize.include? ("Movement Restrictions").titleize }
        quarantine_index = lines_of_text.index { |x| x.titleize.include? ("Quarantine Information").titleize }
        transportation_index = lines_of_text.index { |x| x.titleize.include? ("Transportation Options").titleize }
        fines_index = lines_of_text.index { |x| x.titleize.include? ("Fines for Non-Compliance").titleize }
        consular_operations_index = lines_of_text.index { |x| x.titleize.include? ("Consular Operations").titleize }
        local_resources_index = lines_of_text.index { |x| x.titleize.include? ("Local Resources").titleize }
        other_links_index = lines_of_text.index { |x| x.titleize.include? ("Other Links").titleize }

        list_of_indices = [country_specific_index, entry_exit_requirements_index, local_resources_index, other_links_index]
        # if s = x.includes... s[i] 

        # this one needs the +1 removed because header is included in line
        if main_content_wrapper && paragraphsection 
          lines_of_text.each_with_index{|x, i| 
            case i
            # important inforamtion section
            when 0..(country_specific_index - 1)
              important_info << x
            # country specific section
            when (country_specific_index)..(testing_index -1) 
              country_specific << x
            when (testing_index)..(entry_exit_requirements_index - 1)
              testing_vaccine << x
            when (entry_exit_requirements_index)..(movement_index - 1)
              entry_exit << x
            when (local_resources_index)..(other_links_index - 1)
              local_resources << x
            when (other_links_index)..(lines_of_text.size)
              other_links << x
            else
              misc << x
            end
          }
        end
       
        if entry_content || main
          lines_of_text.each_with_index{|x, i| 
            case i
            # important inforamtion section
            when 0..(country_specific_index - 1)
              important_info << x
            # country specific section
            when (country_specific_index + 1)..(testing_index -1) 
              country_specific << x
            # not addiing +1 because need header
            when (testing_index)..(entry_exit_requirements_index - 1)
              testing_vaccine << x
            when (entry_exit_requirements_index + 1)..(movement_index - 1)
              entry_exit << x
            when (local_resources_index + 1)..(other_links_index - 1)
              local_resources << x
            when (other_links_index + 1)..(lines_of_text.size - 3)
              other_links << x
            else
              if !(list_of_indices.include? i)
                misc << x
              end 
            end
          }
        end

        # # turn array into string
        # movement_restrictions.join('\n') 
        # quarantine.join('\n') 
        # transportation.join('\n') 
        # fines.join('\n') 
        # consular_operations.join('\n') 
  
        all_embassy_info["important_info"] = important_info.join('') 
        all_embassy_info["country_specific"] = country_specific.join('') 
        all_embassy_info["testing_vaccine"] = testing_vaccine.join('') 
        all_embassy_info["entry_exit"] = entry_exit.join('')  
        all_embassy_info["local_resources"] = local_resources.join('') 
        all_embassy_info["other_links"] = other_links.join('')  
        all_embassy_info["misc"] = misc.join('')  

        # all_embassy_info["movement_restrictions"] = movement_restrictions
        # all_embassy_info["quarantine"] = important_info
        
        all_embassy_info
      end
    end
  end
end
