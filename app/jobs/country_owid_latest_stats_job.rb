require 'sidekiq-scheduler'

class CountryOwidLatestStatsJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    ExtractByCountryCommands::LatestStatsByCountryCommand.new().execute
  end
end
