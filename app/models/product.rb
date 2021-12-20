class Product < ApplicationRecord
  validates :name, :price, :inventory, :unit, presence: true
  validates :name, length: {maximum: Settings.length.digit_255}
  validates :price, numericality: {only_integer: true,
                                   greater_than_or_equal_to: 0},
                    allow_blank: true
  validates :inventory, numericality: {only_integer: true,
                                       greater_than_or_equal_to: 0},
                        allow_blank: true
  validates :unit, length: {maximum: Settings.length.digit_50}

  belongs_to :category
  delegate :title, to: :category, prefix: :category
  ransack_alias :category, :category_id_or_category_parent_id
  scope :featured_products,
        (lambda do |max|
          order(rating: :desc).limit(max)
        end)
  scope :pluck_attr,
        (lambda do |id, attr|
          where(id: id).pluck(attr)
        end)
  scope :basic_product_info,
        (lambda do |id|
          select(:id, :name, :price, :inventory).find_by(id: id)
        end)
  scope :search_by_range,
        (lambda do |name, range|
           where(name => (range[:min]..range[:max])) if range.present?
         end)
  scope :search_by_name,
        (lambda do |keyword|
           where(["name LIKE ?", "%#{keyword}%"]) if keyword.present?
         end)
  scope :search_by_category,
        (lambda do |ids|
          where(category_id: ids) if ids.present?
        end)
  scope :related_products,
        (lambda do |product|
           ids = if product.has_parent_category?
                   product.parent_category.children.pluck(:id)
                 else [product.category.id]
                 end
           where category_id: ids
         end)
  scope :update_inventory,
        (lambda do |id, inventory|
          find_by(id: id).update_column(:inventory, inventory)
        end)

  def parent_category
    category.parent
  end

  def has_parent_category?
    parent_category.present?
  end
end
