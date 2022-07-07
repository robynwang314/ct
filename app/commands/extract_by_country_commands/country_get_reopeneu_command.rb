module ExtractByCountryCommands
  class CountryGetReopeneuCommand
    def execute
      json_visa = CovidRawDatum.find_by(
        data_source: "ReopenEU"
      )["raw_json"]

      all_comments_list = []
      
      if ReopenEuByCountry.all.length  == 0 
        json_visa.each do |country| 
          next if country["nutscode"] == "OTC"

          sorted_comments_list = build_comments(country)

          country_name = ISO3166::Country.find_country_by_alpha3(country["nutscode"]).iso_short_name 
          ReopenEuByCountry.create( country_code: country["nutscode"], data_source: "ReopenEU", raw_json: sorted_comments_list )
        end
      else
        json_visa.each do |country| 
          next if country["nutscode"] == "OTC"
          sorted_comments_list = build_comments(country)

          reopen_eu_country = ReopenEuByCountry.find_by(country_code: country["nutscode"])
          reopen_eu_country.update(raw_json: sorted_comments_list, updated_at: Time.current)
        end
      end
    end

    private

    def build_comments(country)
      all_comments_organized = []
      get_by_domain = country["indicators"].select {|data| data["comment"] != ""}

      get_by_domain.each_with_object({}) do |c| 
        comment = { }
        comment["domain_id"] =  c["domain_id"]
        comment["domain_name"] = c["domain_name"]
        comment["indicator_id"] = c["indicator_id"]
        comment["indicator_name"] = c["indicator_name"]
        comment["comment"] = c["comment"]
        comment["value"] = c["value"]

        all_comments_organized << comment
      end
      # return sorted comments
      return all_comments_organized.group_by { |d| d["domain_name"] }
    end 
  
  end
end
