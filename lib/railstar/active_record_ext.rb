# encoding: utf-8
module Railstar
  module ActiveRecordExt
    module ClassMethods
      def truncation
        return if self.count > 0
        self.truncation!
      end
      
      def truncation!
        table_name = self.to_s.underscore.pluralize
        file_name = "#{table_name}.yml"
        file_path = File.join(Rails.root, "resources", "db", file_name)
        raise "#{file_path} file not found."  unless File.exist?(file_path)
        self.transaction do
          case self.connection.adapter_name
          when "SQLite"
            self.connection.execute("DELETE FROM `#{self.table_name}`")
          else
            self.connection.execute("TRUNCATE TABLE `#{self.table_name}`")
          end
          YAML.load_file(file_path).each do |key, value|
            if value.is_a?(Hash)
              self.create value
            else
              self.create key if key.is_a?(Hash)
            end
          end
        end
      end
    end

    module InstanceMethods
    end

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include InstanceMethods
      end
    end
  end
end
