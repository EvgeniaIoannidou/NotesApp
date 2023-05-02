class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.integer :requester_id
      t.integer :requested_id
      t.integer :status

      t.timestamps
    end
  end
end
