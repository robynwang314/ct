module ExtractByCountryCommands
  class TravelAdvisoryByCountryCommand

    def execute
      all_travel_advisory = CovidRawDatum.find_by(
        data_source: "Advisory"
      )

      if all_travel_advisory.nil? || all_travel_advisory.blank?
        GetRawDataCommands::AddTravelAdvisoryCommand.new().execute
      end

      if TravelAdvisoryRawDatum.all.length == 0
        all_travel_advisory.raw_json.each do |country, data|
          TravelAdvisoryRawDatum.create(country_name: data["name"], country_code: country, raw_json: data )
        end
      else
        all_travel_advisory.raw_json.each do |country, data|
          country_alert = TravelAdvisoryRawDatum.find_by(country_code: country)
          country_alert.update(raw_json: data, updated_at: Time.current)
        end
      end
    end

  end
end
