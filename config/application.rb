require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module DnInternTungLaiEcommerce
  class Application < Rails::Application
    def get_host
      if Rails.env.production?
        "tung-lai-ecommerce.herokuapp.com"
      else
        "localhost"
      end
    end

    def get_default_port
      Rails.env.production? ? 5000 : 3000
    end

    config.load_defaults 6.1
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.time_zone = "Hanoi"
    # Action mailer settings
    config.action_mailer.raise_delivery_errors = false
    config
      .action_mailer
      .default_url_options = {host: get_host,
                              port: ENV["PORT"] || 3000,
                              protocol: Rails.env.production? ? :https : :http}
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      user_name: ENV["GMAIL_USERNAME"],
      password: ENV["GMAIL_PASSWORD"],
      authentication: "plain",
      enable_starttls_auto: true
    }
  end
end
