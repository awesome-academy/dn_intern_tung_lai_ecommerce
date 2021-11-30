FactoryBot.define do
  factory :category do |f|
    f.parent_id {Category.first&.id || ""}
    f.title {Faker::Lorem.sentence(word_count: rand(1..3))}
    f.description {Faker::Lorem.sentence(word_count: rand(5..10))}
  end
end
