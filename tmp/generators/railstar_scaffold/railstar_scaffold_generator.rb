class RailstarScaffoldGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_singular_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super
    
    @model_name = @name
    @controller_name = args.first && (args.first.include?(":") ? @name : args.shift) || @name
    @table_name = file_name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)
      
      # Controller, helper, views, and test directories.
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('spec/controllers', controller_class_path))

      for action in scaffold_views
        m.template(
          "view_#{action}.html.erb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end

      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      unless options[:skip_migration]
        m.migration_template(
          'model:migration.rb', 'db/migrate', 
          :assigns => {
            :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}",
            :attributes     => attributes
          }, 
          :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
        )
      end

      for partial in scaffold_partials
        m.template(
          "partial_#{partial}.html.erb",
          File.join('app/views', controller_class_path, controller_file_name, "_#{partial}.html.erb")
        )
      end

      m.template('controller_spec.rb', File.join('spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb"))
      m.template('helper.rb',          File.join('app/helpers',      controller_class_path, "#{controller_file_name}_helper.rb"))
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} railstar_scaffold ModelName ControllerName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration",
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end

    def scaffold_views
      %w[ index show new edit confirm destroy ]
    end
    
    def scaffold_partials
      %w[ form detail ]
    end

    def model_name
      class_name.demodulize
    end
end
