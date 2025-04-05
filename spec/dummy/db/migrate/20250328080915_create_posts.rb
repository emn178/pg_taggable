class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    enable_extension('citext') unless extensions.include?('citext')
    enable_extension('uuid-ossp') unless extensions.include?('uuid-ossp')

    create_table :posts do |t|
      t.string :type
      t.bigint :user_id
      t.string :title
      t.string :strings, array: true, default: []
      t.text :texts, array: true, default: []
      t.integer :integers, array: true, default: []
      t.citext :citexts, array: true, default: []
      t.uuid :uuids, array: true, default: []

      t.timestamps

      t.index :user_id
      t.index :strings, using: 'gin'
      t.index :texts, using: 'gin'
      t.index :integers, using: 'gin'
      t.index :citexts, using: 'gin'
      t.index :uuids, using: 'gin'
    end
  end
end
