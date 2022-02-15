module AddRawDataCommands
  class AddReopeneuCommand
    include HTTParty
    require 'json'

    attr_reader :alpha3

    def initialize(alpha3:)
      @alpha3 = alpha3
    end

    def execute
      all_raw_data = get_all_raw_data

      json_visa = CovidRawDatum.where(
        data_source: "ReopenEU"
      )[0]["raw_json"]

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

    private

    def get_all_raw_data
      raw_data = CovidRawDatum.where(
        data_source: "ReopenEU"
      )

      if raw_data.empty?
        new_raw_data = CovidRawDatum.new(data_source: "ReopenEU", raw_json: JSON.parse(get_all_reopenEU_data))
        new_raw_data.save
        return new_raw_data
      end
      
      existing_data = raw_data.where("updated_at > ?", 1.day.ago)
      
      return raw_data if !existing_data.empty?

      raw_data.update(raw_json: JSON.parse(get_all_reopenEU_data), updated_at: Time.current)

      return raw_data
    end

    def get_all_reopenEU_data
      HTTParty.get('https://reopen.europa.eu/api/covid/v1/eutcdata/data/en/all/all').as_json
    end
  
  end
end
