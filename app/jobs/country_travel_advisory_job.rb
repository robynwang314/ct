require 'sidekiq-scheduler'

class CountryTravelAdvisoryJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    ExtractByCountryCommands::TravelAdvisoryByCountryCommand.new().execute
  end
end
