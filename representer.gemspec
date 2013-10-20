# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "representer/version"

Gem::Specification.new do |s|
  s.name        = "representer"
  s.version     = Representer::VERSION
  s.authors     = ["Marcin Bunsch", "Michal Bugno", "Antek Piechnik"]
  s.email       = ["marcin@futuresimple.com"]
  s.homepage    = ""
  s.summary     = %q{Representer - take control of representation of your objects!}
  s.description = %q{Representer - take control of representation of your objects!}

  s.rubyforge_project = "representer"

  s.add_dependency "yajl-ruby"

  s.add_development_dependency "activerecord", "~>3.2.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest"
  s.add_development_dependency "mocha"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "active_model_serializers"
  s.add_development_dependency "simplecov"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
