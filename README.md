# PgTaggable
A simple tagging gem for Rails using PostgreSQL array.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "pg_taggable"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install pg_taggable
```

## Usage
### Setup
Add array columns and index to your table. For example:
```Ruby
class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :tags, array: true, default: []

      t.timestamps

      t.index :tags, using: 'gin'
    end
  end
end
```

Indicate that attribute is "taggable" in a Rails model, like this:
```Ruby
class Post < ActiveRecord::Base
  taggable :tags
end
```

### Modify
You can modify it like normal array
```Ruby
#set
post.tags = ['food', 'travel']

#add
post.tags += ['food']
post.tags += ['food', 'travel']
post.tags << 'food'

#remove
post.tags -= ['food']
```

### Queries
#### any_#{tag_name}
Find records with any of the tags.
```Ruby
Post.where(any_tags: ['food', 'travel'])
```

You can use with `not`
```Ruby
Post.where.not(any_tags: ['food', 'travel'])
```

#### all_#{tag_name}
Find records with all of the tags
```Ruby
Post.where(all_tags: ['food', 'travel'])
```

#### #{tag_name}_in
Find records that have all the tags included in the list
```Ruby
Post.where(tags_in: ['food', 'travel'])
```

#### #{tag_name}_eq
Find records that have exact same tags as the list, order is not important
```Ruby
Post.where(tags_eq: ['food', 'travel'])
```

#### #{tag_name}
Find records that have exact same tags as the list, order is important. This is the default behavior.
```Ruby
Post.where(tags: ['food', 'travel'])
```

Assume a post has tags: 'A', 'B'
|Method|Query|Matched|
|-|-|-|
|any_tags|A|True|
|any_tags|A, B|True|
|any_tags|B, A|True|
|any_tags|A, B, C|True|
|all_tags|A|True|
|all_tags|A, B|True|
|all_tags|B, A|True|
|all_tags|A, B, C|False|
|tags_in|A|False|
|tags_in|A, B|True|
|tags_in|B, A|True|
|tags_in|A, B, C|True|
|tags_eq|A|False|
|tags_eq|A, B|True|
|tags_eq|B, A|True|
|tags_eq|A, B, C|False|
|tags|A|False|
|tags|A, B|True|
|tags|B, A|False|
|tags|A, B, C|False|

### Class Methods
#### taggable(name, unique: true)
Indicate that attribute is "taggable".

#### unique: true
You can use `unique` option to ensure that tags are unique. It will be deduplicated before saving. The default is `true`.

```Ruby
# taggable :tags, unique: true
post = Post.create(tags: ['food', 'travel', 'food'])
post.tags
# => ['food', 'travel']

# taggable :tags, unique: false
post = Post.create(tags: ['food', 'travel', 'food'])
post.tags
# => ['food', 'travel', 'food']
```

#### #{tag_name}
Return unnested tags. The column name will be `tag`, For example:
```Ruby
Post.tags
# => #<ActiveRecord::Relation [#<Post tag: "food", id: nil>, #<Post tag: "travel", id: nil>, #<Post tag: "travel", id: nil>, #<Post tag: "technology", id: nil>]>

Post.tags.size
# => 4

Post.tags.distinct.size
# => 3

Post.tags.distinct.pluck(:tag)
# => ["food", "travel", "technology"]

Post.tags.group(:tag).count
# => {"food"=>1, "travel"=>2, "technology"=>1}
```

#### uniq_#{tag_name}
Return an array of unique tag strings.
```Ruby
Post.uniq_tags
# => ["food", "travel", "technology"]

# equal to
Post.tags.distinct.pluck(:tag)
```

#### count_#{tag_name}
Calculates the number of occurrences of each tag.
```Ruby
Post.count_tags
# => {"food"=>1, "travel"=>2, "technology"=>1}

# equal to
Post.tags.group(:tag).count
```

### Case Insensitive
If you use `string` type, it is case sensitive.
```Ruby
# tags is string[]
post = Post.create(tags: ['food', 'travel', 'Food'])
post.tags
# => ['food', 'travel', 'Food']
```

If you want case insensitive, you need to use `citext`
```Ruby
class CreatePosts < ActiveRecord::Migration[8.0]
  enable_extension('citext') unless extensions.include?('citext')

  def change
    create_table :posts do |t|
      t.citext :tags, array: true, default: []

      t.timestamps

      t.index :tags, using: 'gin'
    end
  end
end
```

You will get the diffent result
```Ruby
# tags is citext[]
post = Post.create(tags: ['food', 'travel', 'Food'])
post.tags
# => ['food', 'travel']
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/pg_taggable  
Author: Chen, Yi-Cyuan (emn178@gmail.com)
