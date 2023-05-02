class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def create
    @friendship = current_user.friendships.build(friendship_params)
    if @friendship.save
      redirect_to users_path, notice: "Friend request sent."
    else
      redirect_to users_path, alert: "Unable to send friend request."
    end
  end

  def update
    if @friendship.accepted!
      redirect_to friends_path, notice: "Friend request accepted."
    else
      redirect_to friends_path, alert: "Unable to accept friend request."
    end
  end

  def destroy
    if @friendship.destroy
      redirect_to friends_path, notice: "Friendship revoked."
    else
      redirect_to friends_path, alert: "Unable to revoke friendship."
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:requested_id)
  end

  def set_friendship
    @friendship = current_user.friendships.find(params[:id])
  end
end
