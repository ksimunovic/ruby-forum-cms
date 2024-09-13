# spec/factories/forums.rb
FactoryBot.define do
  factory :forum do
    name { Faker::Lorem.words(number: 3).join(' ')[0, 32] }
    admin_only { Faker::Boolean.boolean }
    admin_only_view { Faker::Boolean.boolean }
  end
end
