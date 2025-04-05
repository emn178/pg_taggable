class Post < ApplicationRecord
  taggable :strings
  taggable :texts, unique: false
  taggable :citexts
  taggable :uuids
  taggable :integers
end
