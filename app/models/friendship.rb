class Friendship < ApplicationRecord
  enum status: { pending: 0, accepted: 1, declined: 2 }

  belongs_to :requester, class_name: "User"
  belongs_to :requested, class_name: "User"

  def self.request(requester, requested)
    friendship = find_or_initialize_by(requester: requester, requested: requested)
    friendship.status = "pending"
    friendship.save
    friendship
  end

  def accept
    update(status: "accepted")
  end

  def decline
    update(status: "declined")
  end

  def cancel
    destroy
  end
end
