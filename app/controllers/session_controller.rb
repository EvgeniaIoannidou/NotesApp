class SessionController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(name: params[:user][:name])

    if !@user
      flash.now.alert = "Username #{params[:user][:name]} was invalid"
      render :new
    elsif @user.password == params[:user][:password]
      session[:user_id] = @user.id # store user_id instead of user name
      redirect_to notes_path, notice: "Logged in!"
    else
      flash.now.alert = "Password was invalid"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
