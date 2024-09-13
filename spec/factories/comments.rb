# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    association :author, factory: :user
    association :post
    comment { nil } # Since it's optional

    trait :with_nested_comments do
      after(:create) do |comment|
        create_list(:comment, 2, comment: comment)
      end
    end
  end
end
