# encoding: utf-8
module Railstar
  class BootstrapGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    def copy_config_file
      copy_file "railstar_config.yml", "config/railstar_config.yml"
      copy_file "staging.rb", "config/environments/staging.rb"
      copy_file "samurai.rb", "config/environments/samurai.rb"
    end
  end
end
