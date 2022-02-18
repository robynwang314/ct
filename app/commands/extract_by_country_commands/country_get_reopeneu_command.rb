module ExtractByCountryCommands
  class CountryGetReopeneuCommand
    include HTTParty
    require 'json'

    attr_reader :alpha3

    def initialize(alpha3:)
      @alpha3 = alpha3
    end

    def execute
      json_visa = CovidRawDatum.find_by(
        data_source: "ReopenEU"
      )["raw_json"]

      specific_country_info = json_visa.select { |country| country["nutscode"] == alpha3 }
      get_domain = specific_country_info[0]["indicators"].select {|data| data["comment"] != ""}     
  
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
      sorted_comments_list = all_comments_list.group_by { |d| d["domain_name"] }
    end
  
  end
end
