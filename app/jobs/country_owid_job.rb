require 'sidekiq-scheduler'

class CountryOwidJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    ExtractByCountryCommands::AllOwidByCountryCommand.new().execute
  end
end
