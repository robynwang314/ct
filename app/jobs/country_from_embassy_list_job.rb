require 'sidekiq-scheduler'

class CountryFromEmbassyListJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    GetAllCountriesFromEmbassyCommand.new().execute
  end
end
