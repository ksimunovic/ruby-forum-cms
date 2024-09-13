# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    subforum { nil }
    is_pinned { Faker::Boolean.boolean }
    is_locked { Faker::Boolean.boolean }

    association :forum
    association :author, factory: :user
  end
end
