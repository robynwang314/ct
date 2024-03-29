module GetRawDataCommands
  class AddEmbassyInformationCommand
    include HTTParty
    require 'json'

    attr_accessor :name, :country, :parse_page, :parse_country, :paragraphsection_exists

    def initialize(name:)
      @name = name
    end

    def execute
      information = get_all_raw_data
      return information
    end

    private

    def info_from_embassy
      # get_list_of_embassy_links
      get_specific_country
      # scrape and build information 
      country_info = build_country_info
      return country_info
    end

    def get_all_raw_data
      raw_data = EmbassyCovidAlert.find_by(
        country_name: name.titleize.to_s
      )

      # if no data, create new entry
      if raw_data.nil? || raw_data.blank?
        country_info_from_embassy = info_from_embassy
        new_raw_data = EmbassyCovidAlert.new(country_name: name.titleize.to_s, data_source: "Embassy", raw_json: country_info_from_embassy)
        new_raw_data.save

        return new_raw_data["raw_json"]
      end
      
      # if data is less than one day old, return 
      existing_data = raw_data["updated_at"] < 1.day.ago

      return raw_data["raw_json"] if !existing_data

      # else update the data
      country_info_from_embassy = info_from_embassy
      raw_data.update(raw_json: country_info_from_embassy, updated_at: Time.current)

      return raw_data["raw_json"]
    end

    def transform_entry_content_to_text(all_content)
      text_content = []
      all_content.to_html.each_line do |content|
        text_content << content
      end
      text_content
    end

    def transform_paragraphsections_to_text(all_content)
      text_content = []
        all_content.to_html.each_line do |content|
        text_content << content
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
      indices = {}

      information_sections.each_with_index do |section, array_index|
        # for germany like pages first section
        if array_index == 0 && paragraphsection_exists
          section_index = all_content_text.index { |x| x.titleize.include? ("Country-Specific Information").titleize }
        # for regular pages first section
        elsif array_index == 0
          section_index = all_content_text.index { |x| x.titleize.include? ("Country-Specific Information").titleize } 
           
          # set index to zero for cases like iceland where "country specific" section does not exist on page
          section_index = 0 unless section_index.present?

          section_index = section_index + 1 

        # for rest of sections
        else
          # find all index of where section is named
          section_indice = all_content_text.each_index.select{|i| all_content_text[i].gsub(/[^\001-\176]+/, "").titleize.include? (section).titleize }

          next if section_indice.blank?;

          if section_indice.length() == 1
            section_index = section_indice[0]
          else
            # return the index that is greater than the index value of the previous section, unless if the one before it is nil
            section_index = section_indice.find {|x| x > indices[information_sections[array_index-1]]} unless indices[information_sections[array_index-1]].nil? #information_sections[array_index-1].nil? 
          end

          # if the one before it is nil, then use the index value that is greater than the index of the section before the previous section
          if indices[information_sections[array_index-1]].nil?
            section_index = section_indice.find {|x| x > indices[information_sections[array_index-2]]}
          end

          section_index
        end
        indices[section] = section_index
      end     
      indices
    end

    def build_country_info
      main_section_keys = Country::SUB_SECTIONS
      all_content_text = all_content
      main_section_index = section_indexes(all_content_text)

      if main_section_index["Country-Specific Information"] == 1
        country_specific_info = main_section_index["Country-Specific Information"]
      elsif main_section_index["Country-Specific Information"] >= 2
        country_specific_info = main_section_index["Country-Specific Information"] - 1
      end

      important_info = []
      country_specific = []
      testing_vaccine = []
      entry_exit = []
      local_resources = []
      other_links = []
      misc = []
      
      all_content_text.each_with_index{|x, index| 
        case index
        # important inforamtion section
        when 0...(country_specific_info)
          important_info << x
        # country specific section
        when (main_section_index["Country-Specific Information"])...(main_section_index["COVID-19 Testing"]) 
          country_specific << x
        when (main_section_index["COVID-19 Testing"])...(main_section_index["Entry and Exit Requirements"])
          testing_vaccine << x
        when (main_section_index["Entry and Exit Requirements"])...(main_section_index["Movement Restrictions"])
          entry_exit << x
        when (main_section_index["Local Resources"])...(main_section_index["Other Links"])
          local_resources << x
        when (main_section_index["Other Links"])..(all_content_text.size - 3)
          other_links << x
        else
          if !main_section_keys.any? {|section_header| x.include? (section_header)}
            misc << x
          end
        end
      }

      all_embassy_info = {}

      all_embassy_info["Important Information"] = important_info.join('') 
      all_embassy_info["Country Specific Information"] = country_specific.join('') 
      all_embassy_info["Testing and Vaccine Information"] = testing_vaccine.join('') 
      all_embassy_info["Entry and Exit Requirements"] = entry_exit.join('')  
      all_embassy_info["Local Resources"] = local_resources.join('') 
      all_embassy_info["Other Links"] = other_links.join('')  
      all_embassy_info["Misc Information"] = misc.join('')  

      all_embassy_info
    end

    def get_country_embassy_link(name)
      country_object = Country.find_by(country: name)
      return country_object.href
      # str_name = name.to_s
      # parse_page.css("a:contains('#{str_name}')").first['href']
    end

    def get_specific_country
     # get travel advisory for a specific country
      specific_country = HTTParty.get(get_country_embassy_link(name.titleize))
      @parse_country ||= Nokogiri::HTML(specific_country)
    end

    # might not need th below anymore if executing GetAllCountriesFromEmbassyCommand
    def get_list_of_embassy_links
      # get list of all countries from embassy's travel advisory site
      document = HTTParty.get("https://travel.state.gov/content/travel/en/traveladvisories/COVID-19-Country-Specific-Information.html")
      @parse_page ||= Nokogiri::HTML(document)
    end
  
  end
end
