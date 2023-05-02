class NoteCollection < ApplicationRecord
  belongs_to :user
  has_many :note_collection_notes, dependent: :destroy
  has_many :notes, through: :note_collection_notes
  before_destroy :remove_note_collection_reference

  private

  def remove_note_collection_reference
    notes.update_all(note_collection_id: nil)
  end
end
