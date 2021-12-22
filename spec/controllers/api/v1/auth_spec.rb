require "rails_helper"

def grape_error attribute, message_type
  I18n.t("grape.errors.format", attributes: attribute,
  message:  I18n.t("grape.errors.messages.#{message_type}"))
end

RSpec.context API::V1::Root, type: :request do
  include GrapeRouteHelpers::NamedRouteMatcher

  describe "POST #login" do
    let(:user){create :user}
    before(:each) do
      post api_v1_login_path, params: params, as: :json
      @response_body = JSON.parse(response.body, symbolize_names: true)
    end

    context "when valid email and password combination" do
      let(:params){{email: user.email, password: user.password}}

      it "should return authentication token" do
        expect(@response_body[:token].blank?).to be false
      end
      it "should have successful response code" do
        expect(response).to have_http_status(201)
      end
    end

    context "when email is not included in request body" do
      let(:params){{password: user.password}}

      it "should response with error response code" do
        expect(response).to have_http_status(422)
      end
      it "should response with error message" do
        expect(@response_body[:error]).to eq(grape_error("email", "presence"))
      end
    end
    context "when password is not included in request body" do
      let(:params){{email: user.email}}

      it "should response with  error response code" do
        expect(response).to have_http_status(422)
      end
      it "should response with error message" do
        expect(@response_body[:error]).to eq(grape_error("password", "presence"))
      end
    end
    context "when email and password are not included in request body" do
      let(:params){{}}

      it "should response with  error response code" do
        expect(response).to have_http_status(422)
      end
      it "should response with error message" do
        errors = [grape_error("email", "presence"), grape_error("password", "presence")]
        expect(@response_body[:error]).to eq(errors.join(", "))
      end
    end
    context "when invalid email and password combination" do
      let(:params){{email: user.email, password: user.password + "123"}}
      it "should return error response code" do
        expect(response).to have_http_status(401)
      end
      it "should return error message" do
        expect(@response_body[:error]).to eq(I18n.t("grape.errors.messages.invalid_email_password"))
      end
    end
  end
end
