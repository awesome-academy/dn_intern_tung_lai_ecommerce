module ApplicationHelper
  def full_title page_title = ""
    base_title = t "app_name"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def translate_price price
    price /= Settings.rates_to.usd if I18n.locale == :en
    number_to_currency price
  end

  def change_path_locale path, locale
    elms = path.split("/")
    return "/#{locale}#{path}" if (elms.length < 2) ||
                                  !elms[1].match?(
                                    /#{I18n.available_locales.join("|")}/
                                  )

    elms[1] = locale
    elms.join("/")
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def use_layout_auth
    @use_layout_auth = true
  end
end
