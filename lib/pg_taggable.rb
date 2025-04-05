require 'pg_taggable/version'
require 'pg_taggable/predicate_handler'
require 'pg_taggable/taggable'

module PgTaggable
end

ActiveSupport.on_load(:active_record) do
  extend PgTaggable::Taggable
end
