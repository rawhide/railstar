# coding: utf-8
module Railstar
  class SearchBase

    attr_accessor :where, :values, :conditions

    def initialize(args=nil)
      if args.is_a? Hash
        args.each do |k,v|
          send("#{k}=", v)
        end
      elsif args.is_a? String
        args.split("&").each do |s|
          k,v = s.split("=", 2)
          k.sub!(/^search\[(.*)\]$/){ $1 }
          send("#{k}=", v)
        end
      end
    end

    def to_params
      ret = {}
      TARGET_COLUMN.each do |c|
        unless eval(c.to_s).blank?
          ret["search[#{c}]"] = eval(c.to_s)
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

    def reset_conditions
      self.where = []
      self.values = {}
    end

    def find(options={})
      reset_conditions
      create_conditions
      target_model.find(:all, options.merge(
          :include => include_association,
          :conditions => where.blank? ? nil : [where.join(" and "), values]
        ))
    end

    def count(options={})
      reset_conditions
      create_conditions
      target_model.count("#{target_model.table_name}.id", options.merge(
          :include => include_association,
          :conditions => where.blank? ? nil : [where.join(" and "), values]
        ))
    end

    #TODO: ishitobi find_by_sqlを追加した
    def find_by_sql(sql)
      target_model.find_by_sql(sql)
    end

    private
    def like(method, table_name=nil)
      if self.conditions.has_key?(method.to_sym)
        value = self.conditions[method.to_sym]
      end
      unless value.blank?
        self.where << "#{with_table_name(table_name,method)} like :#{method}"
        self.values[method] = "%#{value}%"
      end
    end

    def eq(method, table_name=nil)
      compare(method, "=", table_name)
    end

    def inc(method, table_name=nil)
      if self.conditions.has_key?(method.to_sym)
        value = self.conditions[method.to_sym]
      end
      unless value.blank?
        self.where << "#{with_table_name(table_name,method)} in (:#{method})"
        self.values[method] = value
      end
    end

    def date_between(method,from,to, table_name=nil)
      self.where << "#{with_table_name(table_name,method)} between :from_#{method} and :to_#{method}"
      self.values["from_#{method}".to_sym] = from
      self.values["to_#{method}".to_sym] = to
    end

    def compare(method, sign, table_name=nil)
      if self.conditions.has_key?(method.to_sym)
        value = self.conditions[method.to_sym]
      end
      unless value.blank?
        self.where << "#{with_table_name(table_name,method)} #{sign} :#{method}"
        self.values[method] = value
      end
    end

    def bit(method, table_name=nil)
      if self.conditions.has_key?(method.to_sym)
        value = self.conditions[method.to_sym]
      end
      unless value.blank?
        self.where << "#{with_table_name(table_name,method)} & :#{method} = :#{method}"
        self.values[method] = value
      end
    end

    def with_table_name table_name, method
      ret = ""
      ret << "#{table_name}." if table_name
      ret << method.to_s
      ret
    end

    def include_assosiation
      nil
    end
  end
end
