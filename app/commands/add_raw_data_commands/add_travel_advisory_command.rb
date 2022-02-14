module AddRawDataCommands
  class AddTravelAdvisoryCommand
    include HTTParty
    require 'json'

    attr_reader :country, :alpha2

    def initialize(country:, alpha2:)
      @alpha2 = alpha2
      @country = country
    end

    def execute
      raw_data = TravelAdvisoryRawDatum.find_by(
        data_source: "Advisory",
        country: country.titleize.to_s
      )

      if raw_data.nil? || raw_data.blank?
        new_raw_data = TravelAdvisoryRawDatum.new(country: country.titleize.to_s, raw_json: get_travel_advisory(alpha2), data_source: "Advisory")
        new_raw_data.save
        return new_raw_data["raw_json"]["data"]
      end
      
      existing_data = raw_data["updated_at"] < 1.day.ago

      return raw_data["raw_json"]["data"] if !existing_data

      raw_data.update(raw_json: get_travel_advisory(alpha2), updated_at: Time.current)
      return raw_data["raw_json"]["data"]
    end

    private

    def get_travel_advisory(alpha2)
      HTTParty.get('https://www.travel-advisory.info/api?countrycode='+alpha2)
    end
  
  end
end
