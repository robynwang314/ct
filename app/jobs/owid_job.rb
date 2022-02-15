class OwidJob < SidekiqApplicationJob
   include Sidekiq::Worker
  #  sidekiq_options queue: 'critical', retry: 0

  def perform
    AddRawDataCommands::AddOwidCommand.new().execute
  end
end
