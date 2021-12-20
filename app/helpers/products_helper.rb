module ProductsHelper
  def should_checked? id
    id_list = params.dig(:filters,
                         :category_in)
    return true if id_list.blank?

    id_list.include?(id.to_s)
  end
end
