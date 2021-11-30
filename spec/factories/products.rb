FactoryBot.define do
  factory :product do
    name {Faker::Commerce.product_name[0..255]}
    description {Faker::Lorem.paragraph(sentence_count: 1)}
    price {rand(0..1000000)}
    rating {rand(0.0..5.0).round(1)}
    inventory {rand(0..1000)}
    unit {Settings.seeder.unit}
    category {FactoryBot.create(:category)}
  end
end
