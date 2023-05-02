class User < ApplicationRecord
  has_many :notes, dependent: :destroy

  has_many :friendships, foreign_key: :requester_id, dependent: :destroy
  has_many :requested_friendships, class_name: "Friendship", foreign_key: :requested_id, dependent: :destroy

  has_many :friends, -> { where(friendships: { status: :accepted }) }, through: :friendships, source: :requested
  has_many :requested_friends, -> { where(friendships: { status: :accepted }) }, through: :requested_friendships, source: :requester

  has_many :note_collections, dependent: :destroy

  def friendship_status(another_user)
    friendship = Friendship.find_by(requester: self, requested: another_user) ||
      Friendship.find_by(requester: another_user, requested: self)

    if friendship.nil?
      "not_friends"
    elsif friendship.status == "pending" && friendship.requester == self
      "friendship_request_sent"
    elsif friendship.status == "pending" && friendship.requested == self
      "friendship_request_received"
    else
      "friends"
    end
  end
end
