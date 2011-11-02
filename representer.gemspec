# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "representer/version"

Gem::Specification.new do |s|
  s.name        = "representer"
  s.version     = Representer::VERSION
  s.authors     = ["Marcin Bunsch"]
  s.email       = ["marcin@futuresimple.com"]
  s.homepage    = ""
  s.summary     = %q{Representers - take control of json/xml representation of your objects!}
  s.description = %q{Representers - take control of json/xml representation of your objects!}

  s.rubyforge_project = "representer"

  s.add_dependency "yajl-ruby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
