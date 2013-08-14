lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "rupture"
  gem.version       = IO.read('VERSION')
  gem.authors       = ["Justin Balthrop", "Alan Malloy"]
  gem.email         = ["git@justinbalthrop.com"]
  gem.description   = %q{Clojure sequence functions for Ruby.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/flatland/rupture"

  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'hamster'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
