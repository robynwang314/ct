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

          country_data = ISO3166::Country.find_country_by_iso_short_name(country.text)

          unless country_data.nil?
            each_country.update(href: country.children[0].attributes["href"], alpha2: country_data.data["alpha2"], alpha3:country_data.data["alpha3"], updated_at: Time.current)
          else 
            each_country.update(href: country.children[0].attributes["href"], updated_at: Time.current)
          end

        end
      else
        all_countries_object.each do |country| 
          country_data = ISO3166::Country.find_country_by_iso_short_name(country.text)

          unless country_data.nil?
            Country.create(country: country.text, href: country.children[0].attributes["href"], alpha2: country_data.data["alpha2"], alpha3:country_data.data["alpha3"])
          else 
           Country.create(country: country.text, href: country.children[0].attributes["href"])
          end
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
