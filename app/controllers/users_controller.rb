class UsersController < ApplicationController
  before_action :require_admin, only: [:index]
  before_action :require_admin_or_owner, only: [:show]

  def index
    @users = if params[:search]
               User.where('lower(name) LIKE ?', "%#{params[:search].downcase}%")
             else
               User.all
             end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.admin?
      redirect_to users_url, alert: "Admin user cannot be deleted."
    else
      @user.destroy
      redirect_to users_url, notice: "User was successfully destroyed."
    end
  end

  def search_users
    @query = params[:query]
    @user = User.where("name LIKE ?", "%#{@query}%")
                .first
    if @user
      render :show
    else
      redirect_to root_path, alert: "User not found."
    end
  end


  def create_friendship
    @friend = User.find(params[:friend_id])
    @friendship = Friendship.new(requester: current_user, requested: @friend)
    if @friendship.save
      redirect_to @friend, notice: "Friend request sent."
    else
      redirect_to @friend, alert: "Failed to send friend request."
    end
  end

  def update_friendship
    @friendship = Friendship.find(params[:id])
    if params[:accept]
      @friendship.accept
      redirect_to current_user, notice: "Friend request accepted."
    elsif params[:decline]
      @friendship.decline
      redirect_to current_user, notice: "Friend request declined."
    elsif params[:revoke]
      @friendship.revoke
      redirect_to current_user, notice: "Friendship revoked."
    else
      redirect_to current_user, alert: "Invalid request."
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:alert] = "You must be an admin to access this page."
      redirect_to root_path
    end
  end

  def require_admin_or_owner
    @user = User.find(params[:id])
    unless current_user.admin? || current_user == @user
      flash[:alert] = "You must be an admin or the owner of this page to access it."
      redirect_to root_path
    end
  end
end
