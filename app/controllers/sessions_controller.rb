class SessionsController < ApplicationController
  skip_before_action :check_login, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to "/events"
      # redirect_to "/users/#{@user.id}"
    else 
      flash[:errors] = ["User does not exist, please register first!"]
      redirect_to "/sessions/new"
    end
  end

  def destroy
    reset_session
    redirect_to "/sessions/new"
  end

end
