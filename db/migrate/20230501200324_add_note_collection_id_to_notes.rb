class AddNoteCollectionIdToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :note_collection_id, :integer
  end
end
