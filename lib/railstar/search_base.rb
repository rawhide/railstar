# -*- coding: utf-8 -*-
#検索ベースモデル
# V2.0

=begin
使用例

class Search::Profile
  include Railstar::SearchBase
end

=end


module Railstar
  module SearchBase

    def self.included base
      base.class_eval do
        attr_accessor :where, :values
        extend ClassMethods
        include ActiveModel::Naming
        include ActiveModel::Validations
        include ActiveModel::Conversion
      end
    end

    module ClassMethods
      #meta data setter
      def column name, options={}
        ActiveRecord::ConnectionAdapters::Column.new(name, options[:default], options[:type] || "string").tap do |col|
          define_method("#{name}=") do |value|
            instance_variable_set("@#{name}", col.type_cast(value))
          end
          define_method(name) do
            unless instance_variable_defined?("@#{name}")
              instance_variable_set("@#{name}", col.default)
            end
            instance_variable_get("@#{name}")
          end
        end
      end

      def set_model klass
        #TODO: klassが存在する（ActiveRecord::Baseの子供として）かどうかをチェックしたい。
        # ActiveRecord::Base.connection.tablesをみて、テーブル名からクラスを探すチェックをいれる
        raise ArgumentError.new('please set ActiveRecord classs') unless defined?(klass)
        define_method(:target_model) do
          klass
        end
      end
    end

    #params(検索条件を渡す)
    def initialize conditions={}
      conditions.each_pair do | key, val |
        writer_method = "#{key}="
        self.send(writer_method, val) if self.respond_to?(writer_method)
      end
    end

    def find(options={})
      reset_conditions
      create_conditions
      if where.blank?
        target_model.scoped
      else
        target_model.where([where.join(" and "), values])
      end
    end

    def count(options={})
      reset_conditions
      create_conditions
      target_model.count("#{target_model.table_name}.id", options.merge(
                                                                        :conditions => where.blank? ? nil : [where.join(" and "), values]
                                                                        ))
    end

    private

    def abstract!
      raise "this is abstract class"
    end

    def create_conditions
      abstract!
    end


    def like _method, table_name, options={}
      value = eval _method.to_s
      if value.present?
        self.where << "#{with_table_name(table_name, _method)} like :#{_method}"
        self.values[_method] = "%#{value}%"
      end
    end

    def eq _method, table_name, options={}
      compare _method, "=", table_name, options
    end

    def inc _method, table_name, options={}
      value = eval _method.to_s
      value = value.splot(",") if value.is_a(String) && value.include?(",")
      if value.present?
        column = options[:column] || _method
        self.where << "#{with_table_name(options[:table_name],column)} in (:#{_method})"
        self.values[_method] = value
      end
    end

    def compare method, sign, table_name, options={}
      return unless sign =~ /^[<>=]{1,2}$/
      value = eval(method.to_s)
      unless value.blank?
        column = options[:column] || method
        self.where << "#{with_table_name(options[:table_name],column)} #{sign} :#{method}"
        self.values[method] = value
      end
    end

    def bit method, table_name, options={}
      value = eval(method.to_s)
      unless value.blank?
        column = options[:column] || method
        self.where << "#{with_table_name(options[:table_name],column)} & :#{method} = :#{method}"
        self.values[method] = value
      end
    end

    def with_table_name table_name, method
      ret = ""
      ret << "#{table_name || target_model.table_name}." if table_name
      ret << method.to_s
      ret
    end

    def reset_conditions
      self.where = []
      self.values = {}
    end
  end
end
