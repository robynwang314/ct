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

  before_create :slugify

  def slugify
    self.slug = name.parameterize
  end

  def self.get_all_our_world_in_data
    HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
  end

  # def self.get_travel_advisory(alpha2)
  #   HTTParty.get('https://www.travel-advisory.info/api?countrycode='+alpha2)
  # end

  # def self.get_all_reopenEU_data
  #   Rails.cache.fetch("reopenEU", expires_in: 24.hour) do
  #     HTTParty.get('https://reopen.europa.eu/api/covid/v1/eutcdata/data/en/all/all').as_json
  #   end
  # end


end
