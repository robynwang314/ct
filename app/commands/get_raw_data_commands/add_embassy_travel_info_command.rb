module GetRawDataCommands
  class AddEmbassyTravelInfoCommand
    include HTTParty
    include CssParser
    require 'json'

    attr_accessor :name, :country, :parse_page, :titleized_name, :parse_country, :country_info, :css

    def initialize(name:)
      @name = name
    end

    def execute
      @titleized_name = name.titleize
      
      @country_info = EmbassyGeneralAlert.find_by(country_name: titleized_name)
    
      create_country_information_raw_data_record unless country_info.present?

      if country_info.present?
        update_country_raw_html unless country_info.raw_html.present?

        @parse_country ||= Nokogiri::HTML(country_info.raw_html) 

        selectors = [{advisory: ".tsg-rwd-csi-travel-advisories"},{messages: ".tsg-rwd-csi-travel-rss"}, {quick_facts: ".tsg-rwd-sidebar-qf-csi-show"}]

        selectors.map {|selector| parse_content(selector)}
      end
    
      country_info
    end

    private

    def load_stylesheets
      country_info.update(href_list_as_string:  create_all_stylesheets_href_array, updated_at: Time.current) unless country_info.href_list_as_string.present?

      all_stylesheets_href = JSON.parse(country_info.href_list_as_string)

      @css = CssParser::Parser.new

      all_stylesheets_href.each do |stylesheet| 
        css.load_uri!(stylesheet)
      end
    end
  

    def match_content_with_css(parsed_content)
      main_content = parsed_content
      load_stylesheets

      css.each_selector do |selector, declarations, specificity|
        next unless selector =~ /^[\d\w\s\#\.\-]*$/ # Some of the selectors given by css_parser aren't actually selectors.
        begin
          elements = main_content.css(selector)
          elements.each do |match|
            match["style"] = [match["style"], declarations].compact.join(" ")
          end
        rescue
          logger.info("Couldn't parse selector '#{selector}'")
        end
      end

      html_with_inline_styles = main_content.to_s 

      return html_with_inline_styles
    end

    def parse_content(selector)
      # dont do anything if thres already info
      return if country_info[selector.keys.first].present?

      # if there isnt...
      parsed_content = parse_country.at_css(selector.values.first) 

      parsed_content_with_css = match_content_with_css(parsed_content)

      country_info[selector.keys.first] = parsed_content_with_css

      country_info.save
    end

    def create_all_stylesheets_href_array
      all_stylesheets
      base_url = "https://travel.state.gov"

      all_stylesheets_href = all_stylesheets.map { |stylesheet| next if  stylesheet["href"].include?(".ico"); base_url + stylesheet["href"]  }.compact

      return all_stylesheets_href
    end

    def all_stylesheets
      stylesheets = parse_country.css('link').attribute(rel: "stylesheet")

      return stylesheets
    end

    def get_country_information
      # get list of all countries from embassy's travel advisory site
      country_info = HTTParty.get("https://travel.state.gov/content/travel/en/international-travel/International-Travel-Country-Information-Pages/#{titleized_name}.html")
    end

    def create_country_information_raw_data_record
      data = get_country_information
  
      country_info = EmbassyGeneralAlert.create(country_name: titleized_name, raw_html: data)

      return country_info
    end

    def update_country_raw_html
      data = get_country_information
      
      country_info.update(raw_html: data, updated_at: Time.current)
    end
  end

end
