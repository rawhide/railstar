# -*- coding: utf-8 -*-
module Railstar
  class SearchBase
    attr_accessor :where, :values

    def initialize(hash)
      self.where = []
      self.values = {}
      if hash
        hash.each do |k,v|
          send("#{k}=", v)
        end
      end
    end

    def to_params
      ret = {}
      TARGET_COLUMN.each do |c|
        unless eval(c.to_s).blank?
          ret[c] = eval(c.to_s)
        end
      end
      return ret
    end

    def to_str_params
      ret = to_params.map do |k,v|
        begin
          "#{k}=#{CGI.escape(v)}"
        rescue
        end
      end
      ret.join("&")
    end

    def base
      create_conditions #TODO: 毎回条件作成をしないようにしたい
      target_model.where([self.where.join(" AND "), values])
    end

    private
    def like(method, options={})
      value = eval(method.to_s)
      unless value.blank?
        column = options[:column] || method
        self.where << "#{with_table_name(options[:table_name],column)} like :#{method}"
        self.values[method] = "%#{value}%"
      end
    end
    
    def eq(method, options={})
      compare(method, "=", options)
    end
    
    def inc(method, options={})
      value = eval(method.to_s)
      value = value.split(",") if value.is_a?(String) && value.include?(",")
      unless value.blank?
        column = options[:column] || method
        self.where << "#{with_table_name(options[:table_name],column)} in (:#{method})"
        self.values[method] = value
      end
    end

    def compare(method, sign, options={})
      return unless sign =~ /^[<>=]{1,2}$/
      value = eval(method.to_s)
      unless value.blank?
        column = options[:column] || method
        self.where << "#{with_table_name(options[:table_name],column)} #{sign} :#{method}"
        self.values[method] = value
      end
    end

    def bit(method, options={})
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
  end
end
