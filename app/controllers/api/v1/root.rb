module API
  module V1
    class Root < Grape::API
      mount API::V1::Auth
      mount API::V1::Orders

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: ENV["SWAGGER_DOC_PATH"],
        hide_format: true
      )
    end
  end
end
