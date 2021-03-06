module GetRawDataCommands
  class AddOwidCommand
   include HTTParty
    require 'json'

    def execute
      raw_data = CovidRawDatum.find_by(
        data_source: "OWID"
      )

      # if it does not exist create a new entry
      if raw_data.nil? || raw_data.blank?
        CovidRawDatum.create(data_source: "OWID", raw_json: get_all_our_world_in_data) 
        return 
      end
      
      # if it does, just update it
      raw_data.update(raw_json: get_all_our_world_in_data, updated_at: Time.current)
    end

    private

    def get_all_our_world_in_data
      HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
    end
  end
end
