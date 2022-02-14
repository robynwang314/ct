class OwidJob < SidekiqApplicationJob
   include Sidekiq::Worker
  #  sidekiq_options queue: 'critical', retry: 1

  def perform
    AddRawDataCommands::AddOwidCommand.new().execute
    puts "================"
    pp "done"
    puts "================"
  end
end
