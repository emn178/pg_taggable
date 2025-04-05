require_relative 'lib/pg_taggable/version'

Gem::Specification.new do |spec|
  spec.name        = 'pg_taggable'
  spec.version     = PgTaggable::VERSION
  spec.authors     = [ 'Yi-Cyuan Chen' ]
  spec.email       = [ 'emn178@gmail.com' ]
  spec.homepage    = 'https://github.com/emn178/pg_taggable'
  spec.summary     = 'A simple tagging gem for Rails using PostgreSQL array.'
  spec.description = 'A simple tagging gem for Rails using PostgreSQL array.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "https://github.com/emn178/pg_taggable"
  spec.metadata['changelog_uri'] = "https://github.com/emn178/pg_taggable/blob/master/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end
  spec.require_paths = [ "lib" ]

  spec.add_dependency 'rails', '>= 8.0.0'
end
