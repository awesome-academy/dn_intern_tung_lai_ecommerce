module API
  module V1
    class Root < Grape::API
      mount API::V1::Auth

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: Settings.swagger_doc_path,
        hide_format: true
      )
    end
  end
end
