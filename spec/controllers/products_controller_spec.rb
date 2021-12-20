require "rails_helper"

def send_index_request params
  get :index, params: params, session: nil
end

def send_show_request product_id
  get :show, params: {id: product_id}
end

def expect_product_found should_found, expected
  expect(assigns(:products))
    .to should_found ? eq(expected) : be_empty
end

def expect_filtered criteria, should_found, options = {}
  params = options.fetch(:params, filters: criteria || {})
  send_index_request params
  expect_product_found should_found, options.fetch(:expected, [product])
end

RSpec.shared_examples "when a filter criteria is missing" do |filter_keys|
  let(:full_params) do
    {filters: {
      name_cont: "def",
      category_in: [product.category.id],
      rating_gteq: 0, rating_lteq: product.rating,
      price_gteq: 0, price_lteq: product.price,
      inventory_gteq: 0, inventory_lteq: product.inventory
    }}
  end
  let(:params) do
    x = full_params.dup
    filter_keys&.each{|key| x[:filters].delete key}
    x
  end
  after{expect_filtered nil, @should_found, params: @params}

  context "when #{filter_keys&.join(', ') || 'nothing'} is missing" do
    it "should return products that meet all other criterias" do
      @params = params
      @should_found = true
    end
    it "should not return products that fail one of the other criterias" do
      @params = params
      if @params[:filters][:name_cont]
        @params[:filters][:name_cont] = "xyz"
      else
        @params[:filters][:price_lteq] = product.price - 1
      end
      @should_found = false
    end
  end
end

RSpec.shared_context "products hierachy" do
  before do
    @product = create(:product, :with_parent_category, parent_cat: create(:category))
    @sibling_product = create(:product, category: @product.category)
    @nephew_product = create(:product, :with_parent_category, parent_cat: @product.parent_category)
  end
end

RSpec.describe ProductsController, type: :controller do
  let(:product){create(:product, name: "abc def ghi")}

  describe "routing" do
    it{should route(:get, "/products").to(action: :index)}
    it{should route(:get, "/products/1").to(action: :show, id: 1)}
  end

  describe "GET #index" do
    it "should return all products when not filtering" do
      expect_filtered nil, true, params: nil
    end

    context "when filtering" do
      context "when filter by name" do
        it "should return no products when no products contain the name parameter" do
          criteria = {name_cont: "xyz"}
          expect_filtered criteria, false
        end

        it "should return products containing the name parameter" do
          criteria = {name_cont: "def"}
          expect_filtered criteria, true
        end

        context "when no name parameter specified" do
          it_behaves_like "when a filter criteria is missing", [:name_cont]
        end
      end

      context "when filter by price" do
        it "should return all products with price in that range" do
          criteria = {price_gteq: 0, price_lteq: product.price}
          expect_filtered criteria, should_found: true
        end

        context "when no price parameter specified" do
          it_behaves_like "when a filter criteria is missing", [:price_gteq, :price_lteq]
        end

        context "when result is empty" do
          after(:each) do
            expect_filtered @criteria, false
          end

          it "should have min = max = 0" do
            @criteria = {price_gteq: 0, price_lteq: 0}
          end
          it "should have min and max less than 0" do
            @criteria = {price_gteq: -1, price_lteq: -1}
          end
          it "should have no products with price in that range" do
            @criteria = {price_gteq: 0, price_lteq: product.price - 1}
          end
        end
      end

      context "when filter by rating" do
        it "should return all products with rating in that range" do
          criteria = {rating_gteq: 0, rating_lteq: product.rating}
          expect_filtered criteria, true
        end

        context "when no rating parameter specified" do
          it_behaves_like "when a filter criteria is missing", [:rating_gteq, :rating_lteq]
        end

        context "when result is empty" do
          after(:each) do
            expect_filtered @criteria, false
          end

          it "should have min and max being negative" do
            @criteria = {rating_gteq: -1, rating_lteq: -1}
          end
          it "should have min and max greater than 5" do
            @criteria = {rating_gteq: 6, rating_lteq: 6}
          end
          it "should have no products in that range" do
            @criteria = {rating_gteq: 0, rating_lteq: product.rating - 1}
          end
        end
      end

      context "when filter by inventory" do
        it "should return all products with inventory in that range" do
          criteria = {inventory_gteq: 0, inventory_lteq: product.inventory}
          expect_filtered criteria, true
        end

        context "when no inventory parameter specified" do
          it_behaves_like "when a filter criteria is missing", [:inventory_gteq, :inventory_lteq]
        end

        context "when result is empty" do
          after(:each) do
            expect_filtered @criteria, false
          end

          it "should have min = max = 0" do
            @criteria = {inventory_gteq: 0, inventory_lteq: 0}
          end
          it "should have min and max less than 0" do
            @criteria = {inventory_gteq: -1, inventory_lteq: -1}
          end
          it "should have no products with inventory in that range" do
            @criteria = {inventory_gteq: 0, inventory_lteq: product.inventory - 1}
          end
        end
      end

      context "when filter by category" do
        include_context "products hierachy"
        after{expect_filtered @criteria, true, expected: @expected}

        context "when only parent parameter is specified" do
          it "should return products with such parent category IDs" do
            @criteria = {category_in: [@product.parent_category.id]}
            @expected = [@product, @sibling_product, @nephew_product]
          end
        end

        context "when only children parameter is specified" do
          it "should return products with such category IDs" do
            @criteria = {category_in: [@product.category.id]}
            @expected = [@product, @sibling_product]
          end
        end

        context "when both parent and children parameters is specified" do
          it "should return products with parent category IDs in parents param and products with category IDs in children params" do
            @criteria = {category_in: [@product.parent_category.id, @product.category.id]}
            @expected = [@product, @sibling_product, @nephew_product]
          end
        end
      end

      context "when filter by all criterias" do
        it_behaves_like "when a filter criteria is missing", nil
      end
    end
  end

  describe "GET #show" do
    context "when product ID does not existed" do
      before{send_show_request(product.id + 1)}

      it{should set_flash[:warning].to(I18n.t("product_not_found"))}
      it{should redirect_to(products_url)}
    end

    context "when product ID exists" do
      include_context "products hierachy"
      before{send_show_request(@product.id)}

      it "should assigns the related products" do
        expect(assigns(:related_products)).to eq([@product, @sibling_product, @nephew_product])
      end
      it "should assigns the product details" do
        expect(assigns(:product)).to eq(@product)
      end
      it{should render_template("show")}
    end
  end
end
