class Railstar::InstallGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_config_file
    template "railstar.yml", "config/railstar.yml"
  end
end
