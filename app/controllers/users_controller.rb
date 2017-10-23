class UsersController < ApplicationController
  skip_before_action :check_login, only: [:create]
  before_action :check_user, only: [:edit, :update]

  def create
    @user = User.new user_params_create
    if @user.save
      flash[:success] = ["You have successfully created a new user, please login now!"]
      redirect_to "/sessions/new"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to "/sessions/new"
    end
  end

  def edit
    @user = current_user
  end

  def update 
    @user = User.find(params[:id])
    if @user.update user_params_update
      redirect_to "/events"
    else
      flash[:errors] = @user.errors.full_messages     
      redirect_to "/users/#{params[:id]}/edit"
    end
  end 

  private
    def user_params_create
      params.require(:user).permit(:first_name, :last_name, :email, :location, :state_id, :password, :password_confirmation)
    end

    def user_params_update
      params.require(:user).permit(:first_name, :last_name, :email, :location, :state_id)
    end

    def check_user
      if current_user != User.find(params[:id])
        redirect_to "/users/#{session[:user_id]}/edit" 
      end
    end
end
