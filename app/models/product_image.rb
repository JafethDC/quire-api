class ProductImage < ApplicationRecord
  before_validation :parse_image, if: :new_record?

  attr_accessor :img_base

  belongs_to :product, inverse_of: :images

  has_attached_file :img, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates :img, attachment_presence: true
  do_not_validate_attachment_file_type :img

  validates :product, presence: true

  private
    def parse_image
      # img is nil if img_base is nil
      self.img = Paperclip.io_adapters.for(img_base)
    end
end
