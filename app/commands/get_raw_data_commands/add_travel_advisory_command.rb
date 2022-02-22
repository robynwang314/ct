module GetRawDataCommands
  class AddTravelAdvisoryCommand
    include HTTParty
    require 'json'

    def execute

      all_travel_advisory = CovidRawDatum.find_by(
        data_source: "Advisory"
      )

      if all_travel_advisory.nil? || all_travel_advisory.blank?
        CovidRawDatum.create(data_source: "Advisory", raw_json: get_travel_advisory["data"])
        return
      end

      all_travel_advisory.update(raw_json: get_travel_advisory["data"], updated_at: Time.current )
    end

    private

    def get_travel_advisory
      HTTParty.get('https://www.travel-advisory.info/api')
    end
  
  end
end
