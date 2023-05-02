class NoteCollectionNote < ApplicationRecord
  belongs_to :note
  belongs_to :note_collection
end
