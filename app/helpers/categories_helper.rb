module CategoriesHelper
  def parent_categories
    Category.where parent_id: nil
  end

  def categories_carousel max = 10
    Category.limit(max)
  end

  def featured_products max = 12
    Product.order(rating: :desc).limit(max)
  end

  def to_filters_hash products
    products.each_with_object({}) do |e, h|
      cat = e.category
      # h[cat.id] = cat.title
      h[cat.parent.id] = cat.parent.title unless cat.parent.nil?
    end
  end

  def snake_join strings
    return "" if strings.empty?

    # strings[0] = Strings::Case.snakecase(strings[0])
    strings.reduce(""){|a, e| a + " #{to_snakecase e}"}
  end

  def to_snakecase string
    Strings::Case.snakecase string
  end
end
