require 'rails_helper'
require 'ostruct'

describe PgTaggable::Taggable do
  let(:tags) { uuid_tags }
  let(:integer_tags) { [ 0, 1, 2, 3, 4 ] }
  let(:uuid_tags) do
    %w[
      f9612d4d-7748-4895-b579-3364c9fffe35
      039e0b55-8cc7-4b03-99e9-e59fbe4e00c9
      8dfd3028-dfc0-4149-8b2c-6b2c18a3b80a
      d723937e-139b-4c90-8635-cda825995cdb
      4e9199c5-5bc1-4ead-b4e4-4a66e7779c9d
    ]
  end

  def setup(column, tags)
    TestPost.create(user_id: 1, title: 'A', column => [ tags[0], tags[1] ])
    TestPost.create(user_id: 2, title: 'B', column => [ tags[1], tags[2] ])
  end

  shared_examples 'any_tags' do |column|
    let(:where_key) { "any_#{column}" }
    let(:tags) { column == 'integers' ? integer_tags : uuid_tags }

    before { setup(column, tags) }

    it { expect(TestPost.where(where_key => [ tags[0] ]).pluck(:title).sort).to eq %w[A] }
    it { expect(TestPost.where(where_key => [ tags[1] ]).pluck(:title).sort).to eq %w[A B] }
    it { expect(TestPost.where(where_key => [ tags[2] ]).pluck(:title).sort).to eq %w[B] }
    it { expect(TestPost.where(where_key => [ tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[A B] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A B] }
    it { expect(TestPost.where(where_key => [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[B] }
    it { expect(TestPost.where(where_key => [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A B] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A B] }
  end

  shared_examples 'all_tags' do |column|
    let(:where_key) { "all_#{column}" }
    let(:tags) { column == 'integers' ? integer_tags : uuid_tags }

    before { setup(column, tags) }

    it { expect(TestPost.where(where_key => [ tags[0] ]).pluck(:title).sort).to eq %w[A] }
    it { expect(TestPost.where(where_key => [ tags[1] ]).pluck(:title).sort).to eq %w[A B] }
    it { expect(TestPost.where(where_key => [ tags[2] ]).pluck(:title).sort).to eq %w[B] }
    it { expect(TestPost.where(where_key => [ tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[A] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[B] }
    it { expect(TestPost.where(where_key => [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[] }
  end

  shared_examples 'tags_in' do |column|
    let(:where_key) { "#{column}_in" }
    let(:tags) { column == 'integers' ? integer_tags : uuid_tags }

    before { setup(column, tags) }

    it { expect(TestPost.where(where_key => [ tags[0] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[1] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[2] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[A] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[B] }
    it { expect(TestPost.where(where_key => [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A B] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[B] }
  end

  shared_examples 'tags_eq' do |column|
    let(:where_key) { "#{column}_eq" }
    let(:tags) { column == 'integers' ? integer_tags : uuid_tags }

    before { setup(column, tags) }

    it { expect(TestPost.where(where_key => [ tags[0] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[1] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[2] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[A] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[B] }
    it { expect(TestPost.where(where_key => [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[] }
    it { expect(TestPost.where(where_key => [ tags[1], tags[0] ]).pluck(:title).sort).to eq %w[A] }
    it { expect(TestPost.where(where_key => [ tags[2], tags[1] ]).pluck(:title).sort).to eq %w[B] }
  end

  describe '.where' do
    context 'when no tag conditions' do
      before { setup(:strings, tags) }

      it { expect(TestPost.where(user_id: 1).pluck(:user_id)).to eq [ 1 ] }
    end

    context 'when any_tags' do
      it_behaves_like 'any_tags', 'strings'
      it_behaves_like 'any_tags', 'citexts'
      it_behaves_like 'any_tags', 'uuids'
      it_behaves_like 'any_tags', 'texts'
      it_behaves_like 'any_tags', 'integers'
    end

    context 'when all_tags' do
      it_behaves_like 'all_tags', 'strings'
      it_behaves_like 'all_tags', 'citexts'
      it_behaves_like 'all_tags', 'uuids'
      it_behaves_like 'all_tags', 'texts'
      it_behaves_like 'all_tags', 'integers'
    end

    context 'when tags_in' do
      it_behaves_like 'tags_in', 'strings'
      it_behaves_like 'tags_in', 'citexts'
      it_behaves_like 'tags_in', 'uuids'
      it_behaves_like 'tags_in', 'texts'
      it_behaves_like 'tags_in', 'integers'
    end

    context 'when tags_eq' do
      it_behaves_like 'tags_eq', 'strings'
      it_behaves_like 'tags_eq', 'citexts'
      it_behaves_like 'tags_eq', 'uuids'
      it_behaves_like 'tags_eq', 'texts'
      it_behaves_like 'tags_eq', 'integers'
    end

    context 'when combine' do
      before { setup(:strings, tags) }

      it { expect(TestPost.where(user_id: 1, any_strings: [ tags[1] ]).pluck(:title).sort).to eq %w[A] }
    end
  end

  describe '.not' do
    before { setup(:strings, tags) }

    context 'when no tag conditions' do
      it { expect(TestPost.where.not(user_id: 1).pluck(:user_id)).to eq [ 2 ] }
    end

    context 'when tag conditions' do
      it { expect(TestPost.where.not(any_strings: [ tags[0] ]).pluck(:title).sort).to eq %w[B] }
      it { expect(TestPost.where.not(any_strings: [ tags[1] ]).pluck(:title).sort).to eq %w[] }
      it { expect(TestPost.where.not(any_strings: [ tags[2] ]).pluck(:title).sort).to eq %w[A] }
      it { expect(TestPost.where.not(any_strings: [ tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(any_strings: [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[] }
      it { expect(TestPost.where.not(any_strings: [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[] }
      it { expect(TestPost.where.not(any_strings: [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A] }
      it { expect(TestPost.where.not(any_strings: [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(any_strings: [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[] }
      it { expect(TestPost.where.not(any_strings: [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[] }

      it { expect(TestPost.where.not(all_strings: [ tags[0] ]).pluck(:title).sort).to eq %w[B] }
      it { expect(TestPost.where.not(all_strings: [ tags[1] ]).pluck(:title).sort).to eq %w[] }
      it { expect(TestPost.where.not(all_strings: [ tags[2] ]).pluck(:title).sort).to eq %w[A] }
      it { expect(TestPost.where.not(all_strings: [ tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(all_strings: [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[B] }
      it { expect(TestPost.where.not(all_strings: [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A] }
      it { expect(TestPost.where.not(all_strings: [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(all_strings: [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(all_strings: [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(all_strings: [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A B] }

      it { expect(TestPost.where.not(strings_in: [ tags[0] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_in: [ tags[1] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_in: [ tags[2] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_in: [ tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_in: [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[B] }
      it { expect(TestPost.where.not(strings_in: [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A] }
      it { expect(TestPost.where.not(strings_in: [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_in: [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_in: [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[] }
      it { expect(TestPost.where.not(strings_in: [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A] }

      it { expect(TestPost.where.not(strings_eq: [ tags[0] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[1] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[2] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[0], tags[1] ]).pluck(:title).sort).to eq %w[B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A] }
      it { expect(TestPost.where.not(strings_eq: [ tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[3], tags[4] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[0], tags[1], tags[2] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[1], tags[2], tags[3] ]).pluck(:title).sort).to eq %w[A B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[1], tags[0] ]).pluck(:title).sort).to eq %w[B] }
      it { expect(TestPost.where.not(strings_eq: [ tags[2], tags[1] ]).pluck(:title).sort).to eq %w[A] }
    end
  end

  describe '.uniq_tags' do
    before { setup(:strings, tags) }

    it { expect(TestPost.uniq_strings.sort).to eq [ tags[0], tags[1], tags[2] ].sort }
  end

  describe '.count_tags' do
    before { setup(:strings, tags) }

    it { expect(TestPost.count_strings).to eq ({ tags[0] => 1, tags[1] => 2, tags[2] => 1 }) }
  end

  describe '.save' do
    context 'when unique is true and citext' do
      it { expect(TestPost.create(citexts: [ 'ab', 'AB', 'ab' ]).citexts).to eq [ 'ab' ] }
      it { expect(TestPost.create(citexts: [ 'AB', 'ab', 'ab' ]).citexts).to eq [ 'AB' ] }
    end

    context 'when unique is true and not citext' do
      it { expect(TestPost.create(strings: [ 'ab', 'AB', 'ab' ]).strings).to eq [ 'ab', 'AB' ] }
      it { expect(TestPost.create(strings: [ 'AB', 'ab', 'ab' ]).strings).to eq [ 'AB', 'ab' ] }
      it { expect(TestPost.create(strings: [ :ab, 'AB', 'ab' ]).strings).to eq [ 'ab', 'AB' ] }
    end

    context 'when unique is false' do
      it { expect(TestPost.create(texts: [ 'ab', 'AB', 'ab' ]).texts).to eq [ 'ab', 'AB', 'ab' ] }
      it { expect(TestPost.create(texts: [ 'AB', 'ab', 'ab' ]).texts).to eq [ 'AB', 'ab', 'ab' ] }
    end
  end

  describe 'when normal model' do
    it { expect(User.all).to eq [] }
  end
end
