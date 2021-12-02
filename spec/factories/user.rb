FactoryBot.define do
  factory :user do |f|
    f.email {Faker::Internet.email[0..255]}
    f.first_name {Faker::Name.first_name[0..50]}
    f.last_name {Faker::Name.last_name[0..50]}
    f.telephone {"098233729"}
    f.address {Faker::Address.full_address[0..255]}
    f.birthday {Date.today}
    f.gender {Faker::Boolean.boolean(true_ratio: 0.5)}
    f.role {rand(0..1)}
    f.password {"12345678@"}
    f.password_confirmation {"12345678@"}
  end
end
