require "rails_helper"

RSpec.describe CartsController, type: :controller do
  describe "GET #index" do
    before(:each) {get :index}

    it {should respond_with(:success)}
    it {should render_template(:index)}
  end

  describe "POST #create" do
    context "when add product to cart" do
      context "with item which is NOT AVAILABLE" do
        it "should return #false" do
          invalid_id = Product.last ? Product.last.id + 1 : 1
          post :create, params: {id: invalid_id}, xhr: true
          expect(assigns(:result)).to eq false
        end
      end

      context "with item which is AVAILABLE" do
        let!(:product) {FactoryBot.create(:product)}

        context "when quantity less than inventory" do
          before :each do
            post :create, params: {id: product.id}, xhr: true
          end

          it "should INCREASE the quantity of product by 1" do
            expect(session[:cart][product.id.to_s]).to eq 1
          end

          it "should return #added" do
            expect(assigns(:result)).to eq :added
          end
        end

        context "when quantity exceed inventory" do
          it "should return #exceeded" do
            product.inventory = 0
            product.save!
            post :create, params: {id: product.id}, xhr: true
            expect(assigns(:result)).to eq :exceeded
          end
        end
      end
    end
  end

  describe "PATCH #update" do
    context "when reduce quantity of product in cart" do
      context "with item NOT EXISTS in cart" do
        it "should return #false" do
          invalid_id = -1
          patch :update, params: {id: invalid_id}, xhr: true
          expect(assigns(:result)).to eq false
        end
      end

      context "with item EXISTS in cart" do
        let!(:product) {FactoryBot.create(:product)}
        before :each do
          post :create, params: {id: product.id}, xhr: true
        end

        context "when quantity still more than 1 after reduced" do
          before :each do
            # set the quantity of product in cart to 2
            session[:cart][product.id.to_s] = 2
            patch :update, params: {id: product.id}, xhr: true
          end

          it "should DECREASE the quantity of product by 1" do
            expect(session[:cart][product.id.to_s]).to eq 1
          end

          it "should return #removed" do
            expect(assigns(:result)).to eq :removed
          end
        end

        context "when quantity less than 1 after reduced" do
          it "should return #pending_remove" do
            patch :update, params: {id: product.id}, xhr: true
            expect(assigns(:result)).to eq :pending_remove
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when remove product from cart" do
      it "should remove item from cart" do
        product = FactoryBot.create(:product)
        post :create, params: {id: product.id}, xhr: true
        delete :destroy, params: {id: product.id}, xhr: true
        expect(session[:cart][product.id.to_s]).to eq nil
      end
    end
  end
end
