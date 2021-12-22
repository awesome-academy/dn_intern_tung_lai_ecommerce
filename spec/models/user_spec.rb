require "rails_helper"
require_relative "shared_examples"

RSpec.describe User, type: :model do
  subject{create :user}
  describe "validations" do
    it "is valid when pass validations" do
      expect(subject).to be_valid
    end
    describe "email" do
      it do
        should validate_presence_of(:email)
          .with_message(I18n.t("errors.messages.required"))
      end
      it do
        should validate_length_of(:email)
          .is_at_most(Settings.length.digit_255)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_255))
      end
      it do
        should validate_uniqueness_of(:email).case_insensitive
                                             .with_message(
                                               I18n.t("errors.messages.taken")
                                             )
      end
      context "has format" do
        let(:FORMAT){User.VALID_EMAIL_REGEX}
        it "matches valid email" do
          valids = %w(test@hosting.vn test1@hosting.vn test-user@hosting.vn test1-user@hosting.vn test_1_today@hosting.vn test-user.123@hosting113.vn nguyen.nhat.tung@sun-asterisk.com)
          valids.each do |email|
            subject.email = email
            expect(subject).to be_valid
          end
        end
        it "disallows invalid email" do
          valids = %w(@ 1 123 -123 a atoz abc123 abc.vn abc.edu.vn abc123.edu.vn test.1_today@hosting_20.vn test1@hosting@edu.vn test1!@hosting.edu.vn)
          valids.each do |email|
            subject.email = email
            subject.valid?
            error_message = subject.errors[:email][0]
            expect(subject).to be_invalid
            expect(error_message).to eq(I18n.t("errors.messages.invalid"))
          end
        end
      end
    end
    describe "first_name" do
      it do
        should validate_presence_of(:first_name)
          .with_message(I18n.t("errors.messages.required"))
      end
      it do
        should validate_length_of(:first_name)
          .is_at_most(Settings.length.digit_50)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_50))
      end
    end
    describe "last_name" do
      it do
        should validate_presence_of(:last_name)
          .with_message(I18n.t("errors.messages.required"))
      end
      it do
        should validate_length_of(:last_name)
          .is_at_most(Settings.length.digit_50)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_50))
      end
    end
    describe "password" do
      it do
        should validate_length_of(:password)
          .is_at_least(Settings.length.digit_8)
          .with_message(I18n.t("errors.messages.too_short",
                               count: Settings.length.digit_8))
      end
      it do
        should validate_length_of(:password)
          .is_at_most(Settings.length.digit_16)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_16))
      end
      it do
        should validate_presence_of(:password_confirmation)
          .with_message(I18n.t("errors.messages.required"))
      end
      it do
        should validate_confirmation_of(:password)
          .with_message(I18n.t("errors.messages.confirmation",
                               attribute: User.human_attribute_name(
                                 :password
                               )))
      end
    end
    context "telephone" do
      it do
        should validate_length_of(:telephone)
          .is_at_least(Settings.length.digit_9)
          .with_message(I18n.t("errors.messages.too_short",
                               count: Settings.length.digit_9))
      end
      it do
        should validate_length_of(:telephone)
          .is_at_most(Settings.length.digit_12)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_12))
      end
      let(:FORMAT){User.VALID_TELEPHONE_REGEX}
      it "should allow valid telephone numbers" do
        valids = "079 577 9798, 0935 805 404, 0795779798, 0566484810"
                 .split(", ")
        valids.each do |telephone|
          subject.telephone = telephone
          expect(subject).to be_valid
        end
      end
      it "should prevent invalid telephone numbers" do
        invalids = "aaaaaaaaa, 123aaaaaa, $123aaaaa 0935 805 xxx"
                   .split(", ")
        invalids.each do |telephone|
          subject.telephone = telephone
          subject.valid?
          error_message = subject.errors[:telephone][0]
          expect(subject).to be_invalid
          expect(error_message).to eq(I18n.t("errors.messages.invalid"))
        end
      end
    end
    describe "address" do
      it do
        should validate_length_of(:address)
          .is_at_most(Settings.length.digit_255)
          .with_message(I18n.t("errors.messages.too_long",
                               count: Settings.length.digit_255))
      end
    end
  end
  describe "enum" do
    describe "role" do
      it do
        should define_enum_for(:role).with_values(user: 0, admin: 1)
                                     .backed_by_column_of_type(:integer)
      end
    end
    describe "gender" do
      it do
        should define_enum_for(:gender).with_values(female: false, male: true)
                                       .backed_by_column_of_type(:boolean)
      end
    end
  end
  describe "callbacks" do
    it "downcase email before save" do
      email = "NHATTUNGNGUYEN.2kgl@gmail.com"
      user = create(:user, email: email)
      expect(user.email).to eq(email.downcase)
    end
  end
  describe "associations" do
    it{should have_many(:orders).dependent(:destroy)}
  end
  describe "methods" do
    describe ".datetime_attributes" do
      it_behaves_like ".datetime_attributes"
    end
  end
end
