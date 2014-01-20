$:.push File.expand_path("../lib", __FILE__)

require 'userapp/version'

Gem::Specification.new do |s|
  s.name        = 'userapp'
  s.version     = UserApp::VERSION
  s.date        = '2014-01-19'
  s.summary     = "UserApp"
  s.description = "User management and authentication for your Ruby app."
  s.authors     = ["Robin Orheden"]
  s.email       = 'robin.orheden@userapp.io'
  s.homepage    = 'https://github.com/userapp-io/userapp-ruby/'
  s.license     = 'MIT'

  s.files       = Dir["{lib}/**/*"] + ["README.md"]
  s.add_dependency "json"
  s.add_dependency "rest-client"
end
