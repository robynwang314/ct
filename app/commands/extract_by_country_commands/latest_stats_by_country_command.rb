module ExtractByCountryCommands
  class LatestStatsByCountryCommand
  
    def execute
      all_latest_stats = CovidRawDatum.find_by(
        data_source: "latest OWID"
      )
      
      if all_latest_stats.nil? || all_latest_stats.blank?
        GetRawDataCommands::AddTodayStatsCommand.new().execute
      end

      if OwidTodayStatsRawDatum.all.length == 0
        all_latest_stats.raw_json.each do |country, data|
          OwidTodayStatsRawDatum.create(country: data["location"], country_code: country, raw_json: data )
        end
      else
        all_latest_stats.raw_json.each do |country, data|
          country_latest_stats = OwidTodayStatsRawDatum.find_by(country_code: country)
          country_latest_stats.update(raw_json: data, updated_at: Time.now())
        end
      end

    end
  end
end