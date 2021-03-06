require 'railstar/engine'
require 'railstar/code_holder'
require 'railstar/search_base'

require 'railstar/helper'
ActionView::Base.send(:include, Railstar::Helper)
require 'railstar/active_record_ext'
ActiveRecord::Base.send(:include, Railstar::ActiveRecordExt)

#require 'railstar/column_comment' if /mysql/i =~ Rails.configuration.database_configuration[Rails.env]["adapter"]

module Railstar
  def self.env
    @env ||= load_env
  end

  def self.load_env
    puts "################# LOAD railstar.yml #################"
    if File.exist?(file = File.join(Rails.root.to_s, 'config', 'railstar.yml'))
      rs = YAML.load_file(file)
      (rs["default"] || {}).merge(rs[Rails.env] || {})
    else
      {}
    end
  end

  def self.code_dir
    self.root + "/../config/resources/code"
  end

  def self.root
    RAILSTAR_ROOT
  end
end

C = Railstar::CodeHolder.new
RAILSTAR_ROOT = File.expand_path(File.dirname(__FILE__))
