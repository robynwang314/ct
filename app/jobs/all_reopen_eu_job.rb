require 'sidekiq-scheduler'

class AllReopenEuJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    GetRawDataCommands::AddReopeneuCommand.new().execute
  end
end
