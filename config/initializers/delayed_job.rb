Delayed::Worker.max_attempts = 5
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.delay_jobs = Rails.env.qa? || Rails.env.demo? || Rails.env.production?

module Delayed::WorkerClassReloadingPatch
  # Override Delayed::Worker#reserve_job to optionally reload classes before running a job
  def reserve_job(*)
    Rails.logger.level = :fatal
    job = super
    Rails.logger.level = :debug

    if job && self.class.reload_app?
      if defined?(ActiveSupport::Reloader)
        Rails.application.reloader.reload!
      else
        ActionDispatch::Reloader.cleanup!
        ActionDispatch::Reloader.prepare!
      end
    end

    job
  end

  # Override Delayed::Worker#reload! which is called from the job polling loop to not reload classes
  def reload!
    # no-op
  end
end
Delayed::Worker.send(:prepend, Delayed::WorkerClassReloadingPatch)