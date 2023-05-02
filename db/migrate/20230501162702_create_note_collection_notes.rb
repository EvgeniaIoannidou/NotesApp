class CreateNoteCollectionNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :note_collection_notes do |t|
      t.references :note, null: false, foreign_key: true
      t.references :note_collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
