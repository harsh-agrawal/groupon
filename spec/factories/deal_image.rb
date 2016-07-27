FactoryGirl.define do

  factory :deal_image do
    image_file_name 'temp_file.jpg'
    image_content_type 'image/jpeg'
    image_file_size '223312'
    image_updated_at Time.current - 1.day
  end

end
