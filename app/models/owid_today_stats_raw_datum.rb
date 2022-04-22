class OwidTodayStatsRawDatum < ApplicationRecord
   belongs_to :country, primary_key: :alpha3, foreign_key: :country_code, optional: true
end
