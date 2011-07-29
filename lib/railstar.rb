require 'railstar/helper'
require 'railstar/column_comment' if /mysql/i =~ Rails.configuration.database_configuration[Rails.env]["adapter"]
require 'railstar/date_helper'
require 'railstar/double_submit_protect'
ActionView::Base.send(:include, Railstar::Helper)

if File.exist?(file = File.join(Rails.root.to_s, 'config', 'railstar_config.yml'))
  RAILSTAR_ENV = YAML.load_file(file)[RAILS_ENV]
else
end

CODE_DIR = Rails.root.to_s + "/resources/code"


