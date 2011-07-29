# -*- coding: utf-8 -*-
module ActiveRecord
  module ConnectionAdapters
    class TableDefinition
      def column(name, type, options = {})
        column = self[name] || ColumnDefinition.new(@base, name, type)
        if options[:limit]
          column.limit = options[:limit]
        elsif native[type.to_sym].is_a?(Hash)
          column.limit = native[type.to_sym][:limit]
        end
        column.precision = options[:precision]
        column.scale = options[:scale]
        column.default = options[:default]
        column.null = options[:null]
        column.comment = options[:comment]
        @columns << column unless @columns.include? column
        self
      end
    end

    class ColumnDefinition
      attr_accessor :comment
      def to_sql
        column_sql = "#{base.quote_column_name(name)} #{sql_type}"
        column_options = {}
        column_options[:null] = null unless null.nil?
        column_options[:default] = default unless default.nil?
        add_column_options!(column_sql, column_options) unless type.to_sym == :primary_key
        self.comment ? "#{column_sql} COMMENT '#{self.comment}'" : column_sql
      end
   end

    module SchemaStatements
      def create_table(table_name, options = {})
        table_definition = TableDefinition.new(self)
        table_definition.primary_key(options[:primary_key] || Base.get_primary_key(table_name.to_s.singularize)) unless options[:id] == false

        yield table_definition if block_given?

        if options[:force] && table_exists?(table_name)
          drop_table(table_name, options)
        end

        create_sql = "CREATE#{' TEMPORARY' if options[:temporary]} TABLE "
        create_sql << "#{quote_table_name(table_name)} ("
        create_sql << table_definition.to_sql
        create_sql << ") "
        create_sql << " COMMENT = '#{options[:comment]}'" if options[:comment]
        create_sql << " #{options[:options]}"
        execute create_sql
        
      end
    end
    
    class Mysql2Adapter
      def add_column(table_name, column_name, type, options = { })
        add_column_sql = "ALTER TABLE #{quote_table_name(table_name)} ADD #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"
        add_column_sql += " COMMENT '#{options[:comment]}'" unless options[:comment].blank?
        add_column_options!(add_column_sql, options)
        execute(add_column_sql)
      end
      
      def change_column(table_name, column_name, type, options = { })
        column = column_for(table_name, column_name)
        
        unless options_include_default?(options)
          options[:default] = column.default        end
        unless options.has_key?(:null)
          options[:null] = column.null        end
        change_column_sql = "ALTER TABLE #{quote_table_name(table_name)} CHANGE #{quote_column_name(column_name)} #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"
        change_column_sql += " COMMENT '#{options[:comment]}'" unless options[:comment].blank?
        add_column_options!(change_column_sql, options)
        add_column_position!(change_column_sql, options)
        execute(change_column_sql)
      end
    end
  end
end

