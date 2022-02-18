require 'sidekiq-scheduler'

class AllTravelAdvisoriesJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    GetRawDataCommands::AddTravelAdvisoryCommand.new().execute
  end
end
