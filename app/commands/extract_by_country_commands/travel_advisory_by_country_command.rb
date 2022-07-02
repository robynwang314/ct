module ExtractByCountryCommands
  class TravelAdvisoryByCountryCommand

    def execute
      all_travel_advisory = CovidRawDatum.find_by(
        data_source: "Advisory"
      )

      if all_travel_advisory.nil? || all_travel_advisory.blank?
        GetRawDataCommands::AddTravelAdvisoryCommand.new().execute
      end

      if TravelAdvisory.all.length == 0
        all_travel_advisory.raw_json.each do |country, data|
          TravelAdvisory.create( country_code: country, advisory: data["advisory"] )
        end
      else
        all_travel_advisory.raw_json.each do |country, data|
          country_alert = TravelAdvisory.find_by(country_code: country) 
          country_alert.update(advisory: data["advisory"], updated_at: Time.current)
        end
      end
    end

  end
end
