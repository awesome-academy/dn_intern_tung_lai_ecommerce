class OrderItem < ApplicationRecord
  before_save :set_current_price
  after_save :update_product_inventory

  validates :quantity, presence: true,
                       numericality: {other_than: Settings.digit.zero}

  belongs_to :order
  belongs_to :product

  class << self
    def datetime_attributes
      %w(created_at updated_at)
    end

    def currency_attributes
      %w(current_price)
    end
  end

  private
  def update_product_inventory
    product.inventory -= quantity
    product.save!
  end

  def set_current_price
    self.current_price = product.price
  end
end
