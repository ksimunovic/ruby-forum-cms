# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@infinapps.com" }
    sequence(:username) { |n| "sample_user#{n}" }
    password { 'password1!' }
    admin_level { 0 }
  end
end
