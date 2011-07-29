Gem::Specification.new do |spec|
  spec.name = "railstar"
  spec.version = "0.0.5"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "Core plugin for Rails"
  spec.files = Dir['*', '*/**/*'].reject{|fn| fn.include?("#{spec.name}-") || fn.include?(".gemspec") }

  spec.has_rdoc = false
  spec.author = "Kazuya Yoshimi"
  spec.email = "  kazuya.yoshimi@gmail.com"
  spec.rubyforge_project = "railstar"
  spec.homepage = "http://raw-hide.co.jp"
  spec.description = "railstar"
end

