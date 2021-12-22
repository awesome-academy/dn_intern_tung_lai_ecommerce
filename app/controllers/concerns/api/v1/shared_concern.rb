module API
  module V1
    module SharedConcern
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error_response(message: e.message, status: 422)
        end

        rescue_from Grape::Exceptions::InvalidMessageBody do |e|
          error_response(message: e.message, status: 400)
        end

        rescue_from :all do |e|
          message = if Rails.env.production?
                      e.message
                    else
                      {message: e.message, type: e.class}
                    end
          error_response(message: message, status: 500)
        end
      end
    end
  end
end
