module AddRawDataCommands
  class AddOwidCommand
   include HTTParty
    require 'json'

    def execute
      raw_data = CovidRawData.where(
        data_source: "OWID"
      )

      if raw_data.empty?
        new_raw_data = CovidRawData.new(data_source: "OWID", raw_json: get_all_our_world_in_data)
        new_raw_data.save
        return
      end
      
      existing_data = raw_data.where("updated_at > ?", 1.day.ago)
      
      return raw_data if !existing_data.empty?

      raw_data.update(raw_json: get_all_our_world_in_data, updated_at: Time.current)

      return raw_data
    end

    private

    def get_all_our_world_in_data
      HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
    end
  end
end
