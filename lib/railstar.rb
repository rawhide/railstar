require 'railstar/engine'

require 'railstar/helper'
ActionView::Base.send(:include, Railstar::Helper)



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
end
