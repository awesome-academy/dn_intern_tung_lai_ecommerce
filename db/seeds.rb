# require_relative "seeds_categories.rb"
require File.expand_path("seeds/categories", __dir__)
class Seeder
  extend CategorySeeds
  N = Settings.length.telephone.max
  class << self
    def sym_to_name sym
      sym = sym.to_s
      sym[0] = sym[0].upcase
      sym.sub! "_", " "
      sym
    end

    def get_category product_name
      product_name.split(" ")[-1]
    end

    def seed_categories
      categories.each do |key, value|
        parent = value && Category.find_by(title: sym_to_name(value))
        Category.create! title: sym_to_name(key),
                        description: Faker::Lorem.paragraphs(
                          number: Settings.seeder.description_paragraphs
                        ).join(". "),
                        parent: parent
      end
    end

    def product_description
      Faker::Lorem.paragraphs(
        number: Settings.seeder.description_paragraphs
      ).join(". ")
    end

    def product_price
      Faker::Number.number(digits: Settings.seeder.digit.price)
    end

    def product_rating
      Faker::Number.between(
        from: Settings.seeder.digit.rating.min,
        to: Settings.seeder.digit.rating.max
      )
    end

    def product_inventory
      Faker::Number.between(
        from: Settings.seeder.digit.inventory.min,
        to: Settings.seeder.digit.inventory.max
      )
    end

    def seed_products
      Settings.seeder.count.products.times do
        name = Faker::Commerce.product_name
        Product.create! name: name,
                      description: product_description,
                      price: product_price,
                      rating: product_rating,
                      inventory: product_inventory,
                      unit: Settings.seeder.unit,
                      category: Category.find_by(title: get_category(name))
      end
    end

    def user_telephone
      telephone = Faker::PhoneNumber.cell_phone
      while (telephone.length < Settings.length.telephone.min) ||
            (telephone.length > Settings.length.telephone.max)
        telephone = Faker::PhoneNumber.cell_phone
      end
      telephone
    end

    def user_address
      "#{Faker::Address.street_address}, "\
      "#{Faker::Address.state}, #{Faker::Address.city}"
    end

    def user_birthday
      Faker::Date.birthday(
        min_age: Settings.seeder.digit.age.min,
        max_age: Settings.seeder.digit.age.max
      )
    end

    def seed_users
      Settings.seeder.count.users.times do |x|
        User.create! email: "seeder.user#{x}@seeder.com",
          first_name: Faker::Name.first_name,
          last_name: "#{Faker::Name.last_name} #{Faker::Name.last_name}",
          telephone: user_telephone,
          address: user_address,
          birthday: user_birthday,
          gender: rand < Settings.seeder.digit.male_probability,
          role: :user,
          password: Settings.seeder.password,
          password_confirmation: Settings.seeder.password
      end
    end

    def seed_admins
      User.create! Settings.seeder.admin.to_hash
    end

    def orders_count
      Faker::Number.between(
        from: Settings.seeder.count.orders.min,
        to: Settings.seeder.count.orders.max
      )
    end

    def order_items_count
      Faker::Number.between(
        from: Settings.seeder.count.order_items.min,
        to: Settings.seeder.count.order_items.max
      )
    end

    def seed_order_items order
      offset = rand(User.where(role: :user).count)
      item = order.order_items.create product: Product.offset(offset).first,
                              quantity: Faker::Number.between(
                                from: Settings.seeder.digit.quantity.min,
                                to: Settings.seeder.digit.quantity.max
                              )
      order.total_price += item.current_price
    end

    def seed_orders_order_items
      User.where(role: :user).find_each do |user|
        orders_count.times do
          order = user.orders.create
          order_items_count.times do
            seed_order_items order
          end
          order.save
        end
      end
    end

    def seed_mailing_user
      User.create! email: "nhattungnguyen.2kgl@gmail.com",
        first_name: "Tùng",
        last_name: "Nguyễn Nhật",
        telephone: "0935 805 404",
        address: "K81/01 Ngô Thì Nhậm, Hòa Khánh, Liên Chiểu, Đà Nẵng",
        birthday: "23/03/2000",
        gender: :male,
        role: :user,
        password: Settings.seeder.password,
        password_confirmation: Settings.seeder.password
    end

    def seed_mailing_order user
      order = user.orders.create!
      order_items_count.times do
        seed_order_items order
      end
      order.save
    end

    def seed_mailing
      u = seed_mailing_user
      seed_mailing_order u
    end

    def seed_all
      seed_categories
      seed_products
      seed_users
      seed_admins
      seed_orders_order_items
      seed_mailing
    end
  end
end
Seeder.seed_all
