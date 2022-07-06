class CountrySerializer < ActiveModel::Serializer
  # attributes :id

   attributes :travel_advisory, :todays_stats, :embassy_advisory, :all_time_data


  # has_one :owid_country_all_time_datum, primary_key: :alpha3, foreign_key: :country_code

  def travel_advisory 
    object.travel_advisory.advisory["message"] 
  end

  def todays_stats
    object.owid_today_stat.todays_stats.slice("last_updated_date", "new_cases", "new_deaths", "total_cases", "total_deaths")
  end

  def embassy_advisory
   object.embassy_alert.raw_json
  end

  def all_time_data
   object.owid_country_all_time_datum.all_time_data["data"]
  end
end