class GetAllCountriesFromEmbassyCommand
    include HTTParty
    require 'json'

    attr_accessor :parse_page
    def execute
      list_of_embassies_page = get_list_of_embassy_links
      all_countries_object = list_of_embassies_page.css("td")

      if Country.all.length > 10 
        all_countries_object.each do |country| 
          each_country = Country.find_by(country: country.text)
          each_country.update(href: country.children[0].attributes["href"], updated_at: Time.current)
        end
      else
        all_countries_object.each do |country| 
          Country.create(country: country.text, href: country.children[0].attributes["href"])
        end
      end
    end

    private

    def get_list_of_embassy_links
      # get list of all countries from embassy's travel advisory site
      document = HTTParty.get("https://travel.state.gov/content/travel/en/traveladvisories/COVID-19-Country-Specific-Information.html")
      @parse_page ||= Nokogiri::HTML(document)
    end
end
