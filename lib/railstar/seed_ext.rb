# encoding: utf-8
module ActiveRecord
  class Base
    def self.truncation
      return if self.count > 0
      self.truncation!
    end

    def self.truncation!
      table_name = self.to_s.underscore.pluralize
      file_name = "#{table_name}.yml"
      file_path = File.join(Rails.root, "resources", "master", file_name)
      puts file_path
      raise "#{file_path} file not found."  unless File.exist?(file_path)
      self.transaction do
        self.connection.execute("TRUNCATE TABLE `#{self.table_name}`")
        YAML::load(File.open(file_path)).each do |key, value|
          if value.is_a?(Hash)
            self.create value
          else
            self.create key if key.is_a?(Hash)
          end
        end
      end
    end

    #TODO: kawashima
    def self.truncation_sql
      return if self.count > 0
      self.truncation_sql!
    end

    def self.truncation_sql!
      table_name = self.to_s.underscore.pluralize
      file_name = "#{table_name}.sql"
      file_path = File.join(Rails.root, "resources", "master", file_name)
      puts file_path
      raise "#{file_path} file not found."  unless File.exist?(file_path)
      self.transaction do
        self.connection.execute("TRUNCATE TABLE `#{self.table_name}`")
        system("mysql -u root jasa < #{file_path}")
      end
    end
  end
end

