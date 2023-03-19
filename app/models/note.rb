class Note < ApplicationRecord
  mount_uploader :image, ImageUploader
end
