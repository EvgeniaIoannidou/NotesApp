class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :note_collection, optional: true
  mount_uploader :image, ImageUploader
  has_many :note_collection_notes, dependent: :destroy
  has_many :note_collections, through: :note_collection_notes
end
