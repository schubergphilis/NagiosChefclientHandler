# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sbp_nagios_chefclient_handler/version"

Gem::Specification.new do |s|
  s.name              = "sbp_nagios_chefclient_handler"
  s.version           = SBP::Nagios::Chefclient::Handler::VERSION
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = false
  s.extra_rdoc_files  = ["LICENSE", "NOTICE"]
  s.authors           = ["Steven Geerts"]
  s.email             = ["sgeerts@schubergphilis.com"]
  s.homepage          = "https://github.com/schubergphilis/NagiosChefclientHandler"
  s.summary           = %q{The Chef client handler for nagios}
  s.description       = s.summary
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]
  s.license           = 'Apache 2.0'
  #s.add_dependency "mixlib-versioning", ">= 1.0.0"
  #s.add_dependency "chef", ">= 10.0.0"
end
