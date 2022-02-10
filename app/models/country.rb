class Country < ApplicationRecord
  has_many :charts
  has_many :documents

  before_create :slugify

  def slugify
    self.slug = name.parameterize
  end

  def self.get_all_our_world_in_data
      HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json)
    # Rails.cache.fetch("allOWID", expires_in: 24.hour) do
    #   # is there a way to search by second key of nested object without knowing the first
    #   HTTParty.get('https://covid.ourworldindata.org/data/owid-covid-data.json', format: :json).parsed_response
    # end
  end

  def self.get_travel_advisory(alpha2)
    HTTParty.get('https://www.travel-advisory.info/api?countrycode='+alpha2)
  end

  def self.get_all_reopenEU_data
    Rails.cache.fetch("reopenEU", expires_in: 24.hour) do
      HTTParty.get('https://reopen.europa.eu/api/covid/v1/eutcdata/data/en/all/all').as_json
    end
  end


end
