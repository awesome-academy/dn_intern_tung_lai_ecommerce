require "rails_helper"

RSpec.shared_examples "shared_presence" do |attributes|
  attributes.each do |attr|
    it {should validate_presence_of(attr)
          .with_message(required_msg)}
  end
end

RSpec.shared_examples "shared_numericality" do |attributes|
  context "only integer" do
    attributes.each do |attr|
      it {should validate_numericality_of(attr).only_integer}
    end
    describe "custom error message" do
      attributes.each do |attr|
        it "produce the correct :#{attr} custom validation error on failure" do
          invalid_integers = [1.0, 2.5, -3.234]
          invalid_integers.each do |invalid_integer|
            subject[attr] = invalid_integer
            subject.valid?
            expect(subject.errors[attr][0]).to eq not_an_integer_msg
          end
        end
      end
    end
  end

  context "greater_than_or_equal_to" do
    attributes.each do |attr|
      it {should validate_numericality_of(attr).is_greater_than_or_equal_to(0)}
    end
    describe "custom error message" do
      attributes.each do |attr|
        it "produce the correct :#{attr} custom validation error on failure" do
          subject[attr] = -1
          subject.valid?
          expect(subject.errors[attr][0]).to eq greater_than_or_equal_to_msg
        end
      end
    end
  end
end

RSpec.describe Product, type: :model do
  subject {
    FactoryBot.create(:product)
  }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it {should belong_to(:category)}
    it {should delegate_method(:title).to(:category).with_prefix(:category)}
  end

  describe "validations" do
    context "name" do
      custom_len = Settings.length.digit_255
      it {should validate_length_of(:name).is_at_most(custom_len)
                                          .with_message(too_long_msg custom_len)}
    end

    context "unit" do
      custom_len = Settings.length.digit_50
      it {should validate_length_of(:unit).is_at_most(custom_len)
                                          .with_message(too_long_msg custom_len)}
    end

    it_behaves_like "shared_presence", %i(name price inventory unit)
    it_behaves_like "shared_numericality", %i(price inventory)
  end

  describe "scopes" do
    context "#featured_products" do
      it "order by rating desc" do
        product_1 = FactoryBot.create(:product, rating: 1.5)
        product_2 = FactoryBot.create(:product, rating: 5)
        featured_products = Product.featured_products 2
        expect(featured_products).to eq [product_2, product_1]
      end
    end

    context "#search_by_range" do
      it "should filter product in range" do
        range = {min: 50000, max: 500000}
        in_range = [FactoryBot.create(:product, price: 100000),
                    FactoryBot.create(:product, price: 499999)]
        filtered_by_range = Product.search_by_range(:price, range)
        expect(filtered_by_range).to eq in_range
      end
    end

    context "#search_by_name" do
      it "should filter product contains keyword (case-insensitively)" do
        products = [FactoryBot.create(:product, name: "COM CoMpUtEr"),
                    FactoryBot.create(:product, name: "Super Computer")]
        keyword = "ComPuTER"
        filtered_by_name = Product.search_by_name(keyword)
        expect(filtered_by_name).to eq products
      end
    end

    context "#search_by_category" do
      it "should filter product included in category list" do
        category = FactoryBot.create(:category)
        product = [FactoryBot.create(:product, category: category)]
        ids = [category.id]
        expect(Product.search_by_category(ids)).to eq product
      end
    end
  end

  describe "methods" do
    let(:parent_category) {FactoryBot.create(:category)}
    let(:child_category) {FactoryBot.create(:category, parent_id: parent_category.id)}
    let(:product) {FactoryBot.create(:product, category: child_category)}
    context "#parent_category" do
      it "should return parent category" do
        expect(product.parent_category).to eq product.category.parent
      end
    end

    context "#has_parent_category?" do
      it "should return parent category" do
        expect(product.has_parent_category?).to eq true
      end
    end

  end
end

private
def required_msg
  I18n.t("errors.messages.required")
end

def too_long_msg len
  I18n.t("errors.messages.too_long", count: len)
end

def not_a_number_msg
  I18n.t("errors.messages.not_a_number")
end

def not_an_integer_msg
  I18n.t("errors.messages.not_an_integer")
end

def greater_than_or_equal_to_msg
  I18n.t("errors.messages.greater_than_or_equal_to", count: 0)
end
