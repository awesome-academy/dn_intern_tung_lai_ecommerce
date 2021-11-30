require "rails_helper"

RSpec.describe Category, type: :model do
  subject {
    FactoryBot.create(:category)
  }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it {should have_many(:products).dependent(:destroy)}

    context "parent & children" do
      it "should be able to do parent tree" do
        cate_child = FactoryBot.create(:category, parent_id: subject.id)
        expect(subject.children).to include(cate_child)
        expect(cate_child.parent).to eq subject
      end
    end
  end

  describe "validations" do
    context "title" do
      it {should validate_presence_of(:title)
            .with_message(invalid_presence_msg :title)}
      it {should validate_length_of(:title)
            .is_at_most(Settings.length.digit_255)
            .with_message(invalid_length_msg :title, Settings.length.digit_255)
      }
    end
  end

  describe "scope" do
    context "#parent_categories" do
      it "should return all parent categories" do
        parent_1 = FactoryBot.create(:category, parent_id: nil)
        parent_2 = FactoryBot.create(:category, parent_id: nil)
        cate_1 = FactoryBot.create(:category, parent_id: parent_1.id)
        cate_2 = FactoryBot.create(:category, parent_id: parent_2.id)

        parent_cates = Category.parent_categories
        expect(parent_cates).to eq [parent_1, parent_2]
      end
    end
  end
end

private
def invalid_presence_msg attr
  I18n.t("errors.messages.required")
end
def invalid_length_msg attr, length
  I18n.t("errors.messages.too_long", count: length)
end
