# -*- coding: utf-8 -*-
require "csv"

module Railstar
  class CodeHolder
    @@start_body = "#DATA"
    @@holder = {}

    def self.method_missing(name, *args)
      @@holder[name] ||= self.load(name, *args)
    end

    def self.clear(name=nil)
      if name
        @@holder[name] = nil
      else
        @@holder = {}
      end
    end

    def self.start_body
      @@start_body
    end
    
    def self.start_body=(str)
      @@start_body = str
    end

    def self.load(name, options={})
      dir = options[:code_dir] || (defined?(CODE_DIR) ? CODE_DIR : '.')
      header = nil
      body_flag = false
      data = { :order => [] }
      disp = {}
      conv = {}
      type_dic = { "integer" => :to_i, "string" => :to_s }
      obj = self.new(name, data, disp)
      reg = /:/

      CSV.foreach(File.join(dir, "#{name}.csv"), :encoding => "UTF-8") do |row|
        if body_flag
          if header
            record = {}
            header.each_with_index do |k,i|
              v = row[i]
              if c = conv[k]
                record[k] = v.send(c)
              else
                record[k] = v
              end
            end
            key = record.delete(:key)
            val = record[:value]
            pos = record[:position]
            data[:order][pos] = key unless pos == 0
            data[key] = record
            data[val] = record
            disp[record[:disp]] = val if record[:disp]
            obj.instance_eval <<-EOS
              def #{key}
                @data["#{key}"][:value]
              end
            EOS
          else
            header ||= []
            row.each do |r|
              if reg =~ r
                key, type = r.split(":")
                conv[key.to_sym] = type_dic[type]
              else
                key = r
              end
              header << key.to_sym
            end
          end
        elsif row.first == @@start_body
          body_flag = true
        else
          obj.instance_eval <<-EOS
            def #{row.first}
              "#{row.last}"
            end
          EOS
        end
      end
      data[:order].compact!
      header.each do |k|
        case k
        when :key
          obj.instance_eval <<-EOS
            def #{k}(val)
              t = @data.select {|k,v| k.kind_of?(String) && v[:value] == val }.first
              t ? t.first : nil
            end
          EOS
        when :value
          # void
        else
          obj.instance_eval <<-EOS
            def #{k}(key)
              k = key.kind_of?(Symbol) ? key.to_s : key
              begin
                @data[k]["#{k}".to_sym]
              rescue NoMethodError
                nil
              end
            end
          EOS
        end
      end
      @@holder[name] = obj
      return obj
    end

    def initialize(name, hash, disp)
      @name = name
      @data = hash
      @disp = disp
    end

    def value(key)
      @data[key.to_s] ? @data[key.to_s][:value] : nil
    end
    alias [] value

    def disp_value(disp_str)
      @disp[disp_str]
    end

    def to_opt
      @data[:order].map{|k| [@data[k][:disp], @data[k][:value]] }
    end

    private

    def data
      @data
    end
  end
end

#C = Railstar::CodeHolder unless defined?(C)
