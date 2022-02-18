require 'sidekiq-scheduler'

class CountryReopenEuJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    ExtractByCountryCommands::CountryGetReopeneuCommand.new().execute
  end
end
