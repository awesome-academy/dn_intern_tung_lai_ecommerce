module CategoriesHelper
  # retrieve catetories in tree format
  def categories_tree
    cat_tree = {}
    # order by parent_id??????
    Category.all.each do |cat|
      if cat[:parent_id].nil?
        cat_tree[cat[:title]] = []
      else
        parent_cat = Category.find_by_id(cat[:parent_id])
        if parent_cat
          cat_tree[parent_cat[:title]] << cat[:title]
        end
      end
    end

    return cat_tree
  end
end
