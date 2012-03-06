class Railstar::ScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
  class_option :model, :type => :string, :default => nil

  def create_scaffold_file
    template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
    
    view_files.each do |f|
      template "views/#{f}.html.erb", "app/views/#{plural_name}/#{f}.html.erb"
    end
  end
  
  def model_class_name
    if options.model.present?
      options.model.singularize.camelize
    else
      class_name.demodulize.singularize
    end
  end

  def controller_class_name
    class_name.pluralize
  end

  def controller_file_name
    controller_class_name.underscore
  end

  def singular_name
    controller_file_name.singularize
  end

  private
  def view_files
    %w(_form _detail confirm index show new edit destroy)
  end
end
