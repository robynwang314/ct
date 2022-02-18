require 'sidekiq-scheduler'

class AllOwidLatestStatsJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    GetRawDataCommands::AddTodayStatsCommand.new().execute
  end
end
