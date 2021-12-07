require "rails_helper"
include SessionsHelper

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    context "user hasn't logged in" do
      before {get :new}

      it {should respond_with(:success)}
      it {should render_template(:new)}
    end
    context "user has logged in" do
      let!(:user) {FactoryBot.create(:user, role: 0)}
      before do
        session[:user_id] = user.id
        get :new
      end

      it {should redirect_to(root_url)}
    end
  end

  describe "POST #create" do
    describe "log in with admin account" do
      let!(:admin) {FactoryBot.create(:user, role: 1)}
      before do
        post :create, params: {user: {email: admin.email, password: admin.password}}
      end

      it {should set_flash[:warning].to(I18n.t("admins_not_allowed"))}
      it {should redirect_to(action: :new)}
    end

    describe "log in with user account" do
      let!(:user) {FactoryBot.create(:user, role: 0)}
      context "valid email & password" do
        before do
          post :create, params: {user: {email: user.email, password: user.password}}
        end

        it {should respond_with(:found)}
        it {should set_session[:user_id].to(user.id)}
        it {should set_flash[:success].to(I18n.t("logged_in_as", name: user.first_name))}
        it {should redirect_to(root_url)}
      end

      context "invalid email or password" do
        before do
          post :create, params: {user: {email: "invalid@test.com", password: "invalid_pwd"}}
        end

        it {should set_flash[:danger].to(I18n.t("email_password_invalid"))}
        it {should redirect_to(action: :new)}
      end
    end
  end

  describe "GET #destroy" do
    let!(:user) {FactoryBot.create(:user, role: 0)}
    before do
      session[:user_id] = user.id
      get :destroy
    end

    it {should redirect_to(root_url)}

    context "current_user.present?" do
      it "remove user from session" do
        expect(session[:user_id]).to eq nil
      end

      it {should set_flash[:success].to(I18n.t("logged_out"))}
    end

    describe "after_action" do
      context "#empty_cart" do
        it {should set_session[:cart].to({})}
      end
    end
  end

  describe "action filters" do
  end
end
