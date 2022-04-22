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
  has_one :travel_advisory_raw_datum, primary_key: :alpha2, foreign_key: :country_code
  has_one :owid_today_stats_raw_datum, primary_key: :alpha3, foreign_key: :country_code
  has_one :owid_country_all_time_datum, primary_key: :alpha3, foreign_key: :country_code
  has_one :reopen_eu_by_country, primary_key: :alpha3, foreign_key: :country_code

  before_create :slugify, :get_country_codes

  def slugify
    self.slug = country.parameterize
  end

  def get_country_codes
    countries = Country.all
    countries.each do |country| 
      if country.alpha2.blank? || country.alpha3.blank? 
        if ISO3166::Country.find_country_by_name(country.country)
          all_country_info = ISO3166::Country.find_country_by_name(country.country)
       
          country.update(alpha2: all_country_info.alpha2, alpha3: all_country_info.alpha3)
         end
      end
    end
  end

  def self.get_all_our_world_in_data
    HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
  end
end
