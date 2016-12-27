require File.join(Rails.root, 'spec','support', 'faker_helpers.rb')

include Faker::ImageHelpers

FactoryGirl.define do
  factory :product_image do
    img_file_name { FFaker::Internet.user_name + '.png' }
    img_base { random_base64_image }
    product
  end
end

