# frozen_string_literal: true

# spec/models/post_spec.rb
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:forum) }
    it { should belong_to(:author).class_name('User').with_foreign_key('user_id') }
    it { should belong_to(:subforum).optional }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(48) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(8).is_at_most(20_000) }
  end

  let!(:pinned_post) { create(:post, is_pinned: true) }

  describe 'scopes' do
    let!(:not_pinned_post) { create(:post, is_pinned: false) }

    it 'pinned posts' do
      expect(Post.pins).to include(pinned_post)
      expect(Post.pins).not_to include(not_pinned_post)
    end

    it 'not pinned posts' do
      expect(Post.not_pinned).to include(not_pinned_post)
      expect(Post.not_pinned).not_to include(pinned_post)
    end
  end

  describe 'methods' do
    let(:post) { create(:post) }

    it '#post_json' do
      expect(post.post_json['author']).to eq(post.author.username)
    end

    it '.author_posts_json' do
      posts = create_list(:post, 3)
      expect(Post.author_posts_json(posts).count).to eq(3)
    end

    it '.author_comments_json' do
      comments = create_list(:comment, 3, post:)
      expect(Post.author_comments_json(comments).count).to eq(3)
    end

    it '.pins_json' do
      pinned_post
      expect(Post.pins_json.count).to eq(1)
    end
  end
end
