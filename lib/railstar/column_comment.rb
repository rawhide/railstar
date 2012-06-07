#coding: utf-8
module ActiveRecord
  module ConnectionAdapters # :nodoc:
    class TableDefinition
       def column(name, type, options = {})
         name = name.to_s
         type = type.to_sym
 
         column = self[name] || new_column_definition(@base, name, type)                                                                                                                                                                                                     
 
         limit = options.fetch(:limit) do
           native[type][:limit] if native[type].is_a?(Hash)
         end
 
         column.limit     = limit
         column.precision = options[:precision]
         column.scale     = options[:scale]
         column.default   = options[:default]
         column.null      = options[:null]
         column.comment   = options[:comment]
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

    module SchemaStatement
      def create_table(table_name, options = {})
        td = table_definition
        td.primary_key(options[:primary_key] || Base.get_primary_key(table_name.to_s.singularize)) unless options[:id] == false
      
        yield td if block_given?

        drop_table(table_name) if options[:force] && table_exists?(table_name)
      
        create_sql = "CREATE#{' TEMPORARY' if options[:temporary]} TABLE "
        create_sql << "#{quote_table_name(table_name)} ("
        create_sql << td.to_sql
        create_sql << ") "
        create_sql << " COMMENT='#{options[:comment]}'" if options[:comment]
        create_sql << " #{options[:options]}"
        execute create_sql
      end
    end
    
    class Mysql2Adapter
      def add_column_options!(sql, options) #:nodoc:
        sql << " DEFAULT #{quote(options[:default], options[:column])}" if options_include_default?(options)
        # must explicitly check for :null to allow change_column to work on migrations
        sql << " NOT NULL" if options[:null] == false
        sql << " COMMENT '#{options[:comment]}'" if !options[:comment].blank?
        sql
      end  
    end
    
  end
end
