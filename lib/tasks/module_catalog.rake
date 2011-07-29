desc "List the gems and plugins that this rails application depends on"
task :catalog => 'catalog:base' do
  puts "gems ==================="
  Rails.configuration.gems.each do |gem|
    print_gems(gem)
  end
  puts
  puts "plugins ================"
    print_plugins
  puts
end

namespace :catalog do
  task :base do
    $gems_rake_task = true
    require 'rubygems'
    require 'rubygems/gem_runner'
    Rake::Task[:environment].invoke
  end
end

def print_gems(gem)
  puts "- #{gem.name} #{gem.requirement.to_s}"
  gem.dependencies.each { |g| print_gem_status(g) }
end

def print_plugins
  Dir[RAILS_ROOT + "/vendor/plugins/*"].each do |p|
    version = nil
    file = p + "/VERSION"
    open(file){|f| version = f.read} if File.exist?(file)
    puts "- #{p.split("/").last}#{version ? " = " + version : ""}"
  end
end
