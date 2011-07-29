module Railstar
  class ScaffoldGenerator < Rails::Generators::NamedBase
#  class ScaffoldGenerator < ResourceGenerator
    source_root File.expand_path('../templates', __FILE__)
    argument :controller_name, :type => :string, :default => ""
    argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
    
    def create_scaffold_file
      template "controller.rb", "app/controllers/#{plural_controller_name}_controller.rb"
      
      view_files.each do |f|
        template "views/#{f}.html.erb", "app/views/#{plural_controller_name}/#{f}.html.erb"
      end
    end
    
    private
    def view_files
      %w(_form _detail confirm index show new edit destroy)
    end
    
    def singular_controller_name
      (controller_name.blank? ? plural_name : singular_name).underscore
    end
    
    def plural_controller_name
      singular_controller_name.pluralize
    end
    
    def singular_controller_path
      singular_controller_name.gsub("/", "_")
    end
    
    def plural_controller_path
      plural_controller_name.gsub("/", "_")
    end
    alias index_helper plural_controller_path
    
    def controller_class_name
      plural_controller_name.classify.pluralize
    end
    
    def model_name
      name.classify
    end
  end
end
