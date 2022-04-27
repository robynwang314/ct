module ExtractByCountryCommands
  class AllOwidByCountryCommand
    def execute

      all_owid_data = CovidRawDatum.find_by(
        data_source: "OWID"
      )
    
      # if it does not exist, run the add_owid_command
      if all_owid_data.nil? || all_owid_data.blank?
        GetRawDataCommands::AddOwidCommand.new().execute
      end

      # else check to make sure there is data, if not create it
      if OwidCountryAllTimeDatum.all.length == 0
        all_owid_data.raw_json.each do |country, data| 
          OwidCountryAllTimeDatum.create(country_code: country, all_time_data: data )
        end
      else
        # else update it
        all_owid_data.raw_json.each do |country, data| 
          country_all_data = OwidCountryAllTimeDatum.find_by(country_code: country)
          country_all_data.update(all_time_data: data, updated_at: Time.current)
        end
      end
    end
  end
end