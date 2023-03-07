app_name = 'project'

Rails.application.config.session_store :active_record_store,
  key: "_#{app_name}_#{Rails.env}_session_id",
  secure: !(Rails.env.development? || Rails.env.test?),
  httponly: true
