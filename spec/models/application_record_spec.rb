require "rails_helper"

RSpec.describe ApplicationRecord do
  shared_examples ".humanize_enum" do
    it "returns translated enum value when exist in locale" do
      expected_value = I18n.t("activerecord.attributes."\
      "#{model.model_name.singular}.#{enum.pluralize}.#{value}")
      expect(User.humanize_enum(enum, value)).to eq(expected_value)
    end

    it "returns translation missing when not exist in locale" do
      expected_value = "translation missing: #{I18n.locale}.activerecord"\
      ".attributes.#{model.model_name.singular}.#{non_enum.pluralize}.#{value}"
      expect(User.humanize_enum(non_enum, value)).to eq(expected_value)
    end
  end

  context ".humanize_enum" do
    it_behaves_like ".humanize_enum" do
      let(:model){User}
      let(:enum){"gender"}
      let(:non_enum){"age"}
      let(:value){"male"}
    end
  end

  context ".attribute_include?" do
    let(:model){User}
    let(:attribute){:datetime_attributes}
    let(:value){"birthday"}
    let(:non_included_value){"phone_number"}

    describe "returns nil" do
      let(:non_attribute){:currency_attributes}
      let(:non_array_attribute){:currency_attributes}
      let(:expected_value){nil}

      it "when not an attribute" do
        expect(model.attribute_include?(non_attribute, value)).to eq(expected_value)
      end

      it "when attribute not return array" do
        expect(model.attribute_include?(non_array_attribute, value)).to eq(expected_value)
      end
    end

    it "returns false when attribute not include value" do
      expect(model.attribute_include?(attribute, non_included_value)).to eq(false)
    end
    it "returns true when attribute includes value" do
      expect(model.attribute_include?(attribute, value)).to eq(true)
    end
  end

  context "#humanized_enum" do
    it "returns nil when non attribute" do
      user = User.first
      non_attribute = :full_name
      expect(user.humanized_enum(non_attribute)).to eq(nil)
    end
    it_behaves_like ".humanize_enum" do
      let(:model){User}
      let(:enum){"gender"}
      let(:non_enum){"age"}
      let(:value){"male"}
    end
  end
end
