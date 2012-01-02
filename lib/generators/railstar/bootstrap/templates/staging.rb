# for staging
Jasa::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  # config.log_level = :debug
  # config.logger = SyslogLogger.new
  #config.cache_store = :mem_cache_store
  config.serve_static_assets = false
  # config.action_controller.asset_host = "http://assets.example.com"
  # config.action_mailer.raise_delivery_errors = false
  #
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = { :host => "lab.raw-hide.jp", :protocol => "http" }

  # config.threadsafe!
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
end
