module GetRawDataCommands
  class AddTodayStatsCommand
   include HTTParty
    require 'json'

    def execute
      all_latest_stats = CovidRawDatum.find_by(
        data_source: "latest OWID"
      )

      if all_latest_stats.nil? || all_latest_stats.blank?
        CovidRawDatum.create(data_source: "latest OWID", raw_json: get_all_latest_owid)
        return
      end
  
      all_latest_stats.update(raw_json: get_all_latest_owid, updated_at: Time.current)
    end

    private

    def get_all_latest_owid
      HTTParty.get('https://covid.ourworldindata.org/data/latest/owid-covid-latest.json', format: :json)
    end
  end
end
