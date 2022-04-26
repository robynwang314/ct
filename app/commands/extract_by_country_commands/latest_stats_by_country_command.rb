module ExtractByCountryCommands
  class LatestStatsByCountryCommand
  
    def execute
      all_latest_stats = CovidRawDatum.find_by(
        data_source: "latest OWID"
      )
      
      if all_latest_stats.nil? || all_latest_stats.blank?
        GetRawDataCommands::AddTodayStatsCommand.new().execute
      end

      if OwidTodayStat.all.length == 0
        all_latest_stats.raw_json.each do |country, data|
          OwidTodayStat.create(country_code: country, todays_stats: data )
        end
      else
        all_latest_stats.raw_json.each do |country, data|
          country_latest_stats = OwidTodayStat.find_by(country_code: country)
          country_latest_stats.update(todays_stats: data, updated_at: Time.current)
        end
      end

    end
  end
end