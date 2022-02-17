module GetRawDataCommands
  class AddTodayStatsCommand
   include HTTParty
    require 'json'

    attr_accessor :name, :alpha3

    def initialize(name:, alpha3:)
      @name = name
      @alpha3 = alpha3
    end

    def execute
      update_latest_covid_raw_data

      latest_stats_by_country = OwidTodayStatsRawDatum.find_by(
        country: name.titleize.to_s
      )

      if latest_stats_by_country.nil? || latest_stats_by_country.blank?
        latest_data_for_country = get_latest_data_by_country
        new_raw_data = OwidTodayStatsRawDatum.new(country: name.titleize.to_s, data_source: "latest OWID", raw_json: latest_data_for_country)
        new_raw_data.save

        return new_raw_data["raw_json"]
      end
     
      existing_data = latest_stats_by_country["updated_at"] < 1.day.ago
     
      return latest_stats_by_country["raw_json"] if !existing_data

      latest_data_for_country = get_latest_data_by_country
      latest_stats_by_country.update(raw_json: latest_data_for_country, updated_at: Time.current)
      
      return latest_stats_by_country["raw_json"]
    end

    private

    def get_latest_data_by_country
      all_data = CovidRawDatum.find_by(
        data_source: "latest OWID"
      )

      return all_data["raw_json"][alpha3] 
    end

    def update_latest_covid_raw_data
      raw_data = CovidRawDatum.find_by(
        data_source: "latest OWID"
      )

      if raw_data.nil? || raw_data.blank?
        new_raw_data = CovidRawDatum.new(data_source: "latest OWID", raw_json: get_all_latest_our_world_in_data)
        new_raw_data.save
        return
      end
      
      existing_data = raw_data["updated_at"] < 1.day.ago

      return if !existing_data
  
      raw_data.update(raw_json: get_all_latest_our_world_in_data, updated_at: Time.current)
    end

    def get_all_latest_our_world_in_data
      HTTParty.get('https://covid.ourworldindata.org/data/latest/owid-covid-latest.json', format: :json)
    end
  end
end
