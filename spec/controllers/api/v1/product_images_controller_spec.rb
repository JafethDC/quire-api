require 'rails_helper'

RSpec.describe Api::V1::ProductImagesController, type: :controller do
  let(:seller) { FactoryGirl.create(:logged_user) }
  let(:product) { FactoryGirl.create(:product, seller_id: seller.id) }

  describe 'GET #index' do
    it "renders a json object with all the product's images" do
      images_count = product.images.size
      get :index, params: { user_id: seller.id, product_id: product.id }
      expect(json_response.size).to eq(images_count)
    end

    it 'returns 200' do
      get :index, params: { user_id: seller.id, product_id: product.id }
      is_expected.to respond_with 200
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      let(:product_image_attrs) { FactoryGirl.attributes_for(:product_image) }

      it 'renders a json object with the passed fields' do
        api_authorization_header(seller.access_token)
        post :create, params: { product_image:  product_image_attrs,
                                product_id:     product.id,
                                user_id:        seller.id }
        expect(json_response[:url]).not_to be_nil
      end

      it 'returns 201' do
        api_authorization_header(seller.access_token)
        post :create, params: { product_image:  product_image_attrs,
                                product_id:     product.id,
                                user_id:        seller.id }
        is_expected.to respond_with 201
      end
    end

    context 'when a field is not provided' do
      let(:product_image_attrs) { FactoryGirl.attributes_for(:product_image, img_base: nil) }

      it 'returns 422' do
        api_authorization_header(seller.access_token)
        post :create, params: { product_image:  product_image_attrs,
                                product_id:     product.id,
                                user_id:        seller.id }
        is_expected.to respond_with 422
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is successfully destroyed' do
      let(:product_image) { FactoryGirl.create(:product_image, product_id: product.id) }

      it 'returns a success message' do
        api_authorization_header(seller.access_token)
        delete :destroy, params: { id:          product_image.id,
                                   product_id:  product.id,
                                   user_id:     seller.id }
        expect(json_response[:success]).to be_truthy
      end

    end
  end
end
