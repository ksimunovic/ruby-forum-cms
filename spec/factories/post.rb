# spec/factories/posts.rb
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    # forum
    subforum { nil }
    is_pinned { Faker::Boolean.boolean }
    is_locked { Faker::Boolean.boolean }
    # author

    association :forum
    association :author, factory: :user
  end
end
