require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryGirl.build(:product) }

  it { expect(product).to be_valid }

  describe '#name' do
    it { expect(product).to validate_presence_of(:name) }
  end

  describe '#description' do
    it { expect(product).to validate_presence_of(:description) }
  end

  describe '#price' do
    it { expect(product).to validate_presence_of(:price) }
    it { expect(product).to validate_numericality_of(:price) }
  end

  describe '#seller' do
    it { expect(product).to validate_presence_of(:seller) }
  end

  describe '#destroy' do
    it 'destroys all the associated images' do
      product = FactoryGirl.create(:product, images_attributes: FactoryGirl.attributes_for_list(:product_image, 3))
      images_ids = product.images.map { |i| i.id }
      product.destroy
      expect(ProductImage.where(id: images_ids)).to be_empty
    end
  end

  describe '.create' do
    it 'creates the images for the sent nested attributes' do
      images_attrs = FactoryGirl.attributes_for_list(:product_image, 3)
      product_attrs = FactoryGirl.attributes_for(:product, images_attributes: images_attrs)
      product = Product.create(product_attrs)
      expect(product.images.size).to eq(3)
    end
  end
end

