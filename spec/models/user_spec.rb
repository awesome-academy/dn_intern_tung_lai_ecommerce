require "rails_helper"

RSpec.describe User, type: :model do
  subject {
    FactoryBot.create(:user)
  }

  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it {should have_many(:orders).dependent(:destroy)}
  end

  describe "has_secure_password" do
    it {should have_secure_password}
  end

  describe "enum" do
    it {should define_enum_for(:role).with_values(user: 0,
                                                  admin: 1)
                                     .backed_by_column_of_type(:integer)}

    it {should define_enum_for(:gender).with_values(female: false,
                                                    male: true)
                                       .backed_by_column_of_type(:boolean)}
  end

  describe "methods" do
    context ".datetime_attributes" do
      it "contains only datetime attributes" do
        expect(User.datetime_attributes).to eq %w(birthday created_at updated_at)
      end
    end

    context "#downcase!" do
      # before_save{email.downcase!}
      it "has #downcase! working properly" do
        upcase_email_user = FactoryBot.build(:user)
        upcase_email_user.email = "TeST@TESt.COM"
        upcase_email_user.save!
        expect(upcase_email_user.email).to eq "test@test.com"
      end
    end
  end

  describe "validations" do
    it "is valid with full valid attributes" do
      expect(subject).to be_valid
    end

    context "email" do
      it {should validate_presence_of(:email)}
      it {should validate_length_of(:email).is_at_most(255)}

      it "do not allow duplicate email storage case-insensitively" do
        duplicate_user = subject.dup
        duplicate_user.email = subject.email.upcase
        expect(duplicate_user).to be_invalid
      end

      # VALID_EMAIL_REGEX = /\A[\w\-.+]+@[a-z\-\d.]+\.[a-z]+\z/i
      it "do not allow emails with wrong format" do
        invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo bar@ @foobar @foobar.com]
        invalid_emails.each do |invalid_email|
          subject.email = invalid_email
          expect(subject).to be_invalid
        end
      end

    end

    context "first_name" do
      it {should validate_presence_of(:first_name)}
      it {should validate_length_of(:first_name).is_at_most(50)}
    end

    context "last_name" do
      it {should validate_presence_of(:last_name)}
      it {should validate_length_of(:last_name).is_at_most(50)}
    end

    context "password" do
      it {should validate_presence_of(:password).ignoring_interference_by_writer}
      it {should validate_length_of(:password).is_at_least(8)}
      it {should validate_length_of(:password).is_at_most(16)}
      it {should validate_confirmation_of(:password)}
    end

    context "telephone" do
      it {should validate_length_of(:telephone).is_at_least(9)}
      it {should validate_length_of(:telephone).is_at_most(12)}

      it "do not allow telephones with wrong format" do
        invalid_phones = []
        invalid_phones << "0a"
        invalid_phones << "0 a"
        invalid_phones << "11"
        invalid_phones << "+84521551478"
        invalid_phones << "+84 254"
        invalid_phones << "33-333"
        invalid_phones << "(333) 333"
        invalid_phones << "033.333"
        invalid_phones << "033-333"
        invalid_phones << "333.333 x3333"
        invalid_phones.each do |invalid_phone|
          subject.telephone = invalid_phone
          expect(subject).to be_invalid
        end
      end
    end

    context "address" do
      it {should validate_length_of(:address).is_at_most(255)}
    end
  end
end
