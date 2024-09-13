# frozen_string_literal: true

# spec/models/comment_spec.rb
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:valid_attributes) { { body: 'This is a comment', user_id: user.id, post_id: post.id } }

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('User').with_foreign_key('user_id') }
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:comment).optional }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_least(2).is_at_most(400) }
  end

  describe '#comment_json' do
    let(:comment) { create(:comment, valid_attributes) }

    it 'returns comment attributes with author username' do
      result = comment.comment_json
      expect(result['author']).to eq(user.username)
      expect(result['body']).to eq('This is a comment')
    end
  end

  describe '.author_comments_json' do
    let(:comments_array) { create_list(:comment, 3, valid_attributes) }

    it 'returns comments array with additional attributes' do
      result = Comment.author_comments_json(comments_array)
      expect(result.length).to eq(3)
      result.each do |comment|
        expect(comment['author']).to eq(user.username)
        expect(comment['post_author']).to eq(post.author.username)
        expect(comment['post_title']).to eq(post.title)
        expect(comment['forum']).to eq(post.forum.name)
      end
    end
  end
end
