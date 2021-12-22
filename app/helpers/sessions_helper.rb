module SessionsHelper
  DEVISE_MESSAGE_TYPES = [:notice, :alert].freeze
  DEVISE_MESSAGE_TYPES_MAPPING = {notice: :info, alert: :danger}.freeze

  def use_custom_flash!
    DEVISE_MESSAGE_TYPES.each do |key|
      next unless flash.key? key.to_s

      flash[DEVISE_MESSAGE_TYPES_MAPPING[key]] = flash[key]
      flash.delete key
    end
  end
end
