require 'rails_helper'
require 'paperclip/matchers'

RSpec.configure do |c|
  c.include Paperclip::Shoulda::Matchers
end

RSpec.describe ProductImage, type: :model do
  let(:product_image) { FactoryGirl.build(:product_image) }

  it { expect(product_image).to be_valid }

  describe '#product' do
    it { expect(product_image).to validate_presence_of(:product) }
  end

  describe '.new' do
    context 'when img_base is not provided' do
      it 'is invalid' do
        other_product_image = FactoryGirl.build(:product_image, img_base: nil)
        other_product_image.valid?
        expect(other_product_image.errors[:img].size).to eq(1)
      end
    end
  end

end
