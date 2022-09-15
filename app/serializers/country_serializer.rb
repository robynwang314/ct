class CountrySerializer < ActiveModel::Serializer
   attributes :travel_advisory, :todays_stats, :reopen_eu, :embassy_covid_advisory, :all_time_data

  def travel_advisory 
    object.travel_advisory.advisory["message"] 
  end

  def todays_stats
    object.owid_today_stat.todays_stats.slice("last_updated_date", "new_cases", "new_deaths", "total_cases", "total_deaths")
  end

  def reopen_eu
    object.reopen_eu_by_country.raw_json unless object.reopen_eu_by_country.nil?
  end

  def embassy_covid_advisory
    object.embassy_covid_alert.raw_json
  end

  def all_time_data
   object.owid_country_all_time_datum.all_time_data["data"]
  end
end
