require 'sidekiq-scheduler'

class OwidJob < SidekiqApplicationJob
   include Sidekiq::Worker

  def perform
    GetRawDataCommands::AddOwidCommand.new().execute
  end
end
