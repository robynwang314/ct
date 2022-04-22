class TravelAdvisoryRawDatum < ApplicationRecord
  self.primary_key = "country_name"
  belongs_to :country, primary_key: :country, foreign_key: :country_name, optional: true
end