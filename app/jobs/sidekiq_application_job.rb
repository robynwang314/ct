class SidekiqApplicationJob
  include Sidekiq::Worker
  class << self
    alias perform_later perform_async

    def delayed_perform(delay, *args)
      # perform_in has issues in test environments. creating this abstraction helps run the perform method inline in tests, while
      # retaining the ability to delay in other environments
      if Rails.env.test? || Rails.env.development?
        perform_async(*args)
      else
        perform_in(delay, *args)
      end
    end

    def cancel!(jid)
      Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86400, 1) }
    end
  end

  def cancelled?
    Sidekiq.redis { |c| c.exists?("cancelled-#{jid}") }
  end
end
