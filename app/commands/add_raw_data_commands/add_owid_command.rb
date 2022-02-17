module AddRawDataCommands
  class AddOwidCommand
   include HTTParty
    require 'json'

    def execute
      raw_data = CovidRawDatum.find_by(
        data_source: "OWID"
      )

      if raw_data.nil? || raw_data.blank?
        new_raw_data = CovidRawDatum.new(data_source: "OWID", raw_json: get_all_our_world_in_data)
        new_raw_data.save
        return;
      end
      
      raw_data.update(raw_json: get_all_our_world_in_data, updated_at: Time.current)
    end

    private

    def get_all_our_world_in_data
      HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
    end
  end
end
