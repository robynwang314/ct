class TravelAdvisoryRawDatum < ApplicationRecord
  self.primary_key = "country_name"
  belongs_to :country, primary_key: :alpha2, foreign_key: :country_code, optional: true
end