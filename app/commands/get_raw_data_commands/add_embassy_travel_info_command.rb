module GetRawDataCommands
  class AddEmbassyTravelInfoCommand
    include HTTParty
    require 'json'

    attr_accessor :name, :country, :parse_page, :parse_country, :paragraphsection_exists

    def initialize(name:)
      @name = name
    end

    def execute
      return all_content

    end

    private

    def all_content 
      get_list_of_embassy_links

      main_content = parse_country.at_css(".tsg-rwd-main-CSI-page-items-tsg_rwd_main_content")

      return main_content.to_html
    end


    def get_list_of_embassy_links
      titleized_name = name.titleize
      # get list of all countries from embassy's travel advisory site
      country_info = HTTParty.get("https://travel.state.gov/content/travel/en/international-travel/International-Travel-Country-Information-Pages/#{titleized_name}.html")

      @parse_country ||= Nokogiri::HTML(country_info)
    end

  end

end
