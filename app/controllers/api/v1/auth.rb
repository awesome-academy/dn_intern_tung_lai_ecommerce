module API
  module V1
    class Auth < Grape::API
      include API::V1::SharedConcern

      desc "Log in with email, password and return "\
           "a bearer authentication token",
           tags: %w(Auth),
           http_codes: [
             {code: 201, message: "Login successfully"},
             {code: 422, message: "Request contain invalid data"},
             {code: 500, message: "Server error"}
           ]
      params do
        requires :email, type: String, documentation: {in: "body"}
        requires :password, type: String, documentation: {in: "body"}
      end
      post "login" do
        user = User.find_by email: params[:email]
        if user&.authenticate params[:password]
          {token: Services::Authentication.sign(user_id: user.id)}
        else
          error!(I18n.t("grape.errors.messages.invalid_email_password"), 401)
        end
      end
    end
  end
end
