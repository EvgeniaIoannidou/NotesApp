class UsersController < ApplicationController
  before_action :require_admin, only: [:index]
  before_action :require_admin_or_owner, only: [:show]

  def index
    @users = User.all
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
