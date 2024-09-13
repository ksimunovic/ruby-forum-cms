# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forum, type: :model do
  subject { build(:forum) }

  it { is_expected.to have_many(:subforums).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(32) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it 'downcases the name before saving' do
    forum = build(:forum, name: 'TESTING')
    forum.save
    expect(forum.reload.name).to eq('testing')
  end
end
