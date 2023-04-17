class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif session[:user]
      @current_user ||= User.find_by(name: session[:user])
    end

    puts "Current user is #{@current_user.name}" if @current_user
    @current_user
  end
end
