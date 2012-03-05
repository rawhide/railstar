$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "railstar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "railstar"
  s.version     = Railstar::VERSION
  s.authors     = ["RAWHIDE. Co., Ltd."]
  s.email       = ["info@raw-hide.co.jp"]
  s.homepage    = "http://raw-hide.co.jp"
  s.summary     = "RAWHIDE. Core Rails Lib"
  s.description = "railstar"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
