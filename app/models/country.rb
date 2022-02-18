class Country < ApplicationRecord
  INFORMATION_SECTIONS = [  "Country-Specific Information",
                            "COVID-19 Testing",
                            "COVID-19 Vaccine",
                            "Entry and Exit Requirements", 
                            "Movement Restrictions",
                            "Quarantine Information",
                            "Transportation Options",
                            "Fines for Non-Compliance",
                            "Consular Operations",
                            "Local Resources",
                            "Other Links"
                          ].freeze

  SUB_SECTIONS = [  "Country-Specific Information",
                    "COVID-19 Testing",
                    "COVID-19 Vaccine",
                    "Entry and Exit Requirements", 
                    "Local Resources",
                    "Other Links"
                  ].freeze

  has_many :charts
  has_many :documents
  has_many :covid_raw_data
  has_many :embassy_raw_data
  has_many :travel_advisory_raw_data
  has_many :owid_today_stats_raw_data
  has_many :owid_country_all_time_data
  has_many :reopen_eu_by_countries

  before_create :slugify

  def slugify
    self.slug = name.parameterize
  end

  def self.get_all_our_world_in_data
    HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
  end
end
