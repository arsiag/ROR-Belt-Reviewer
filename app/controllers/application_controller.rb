class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def all_states
  	State.all
  end

  helper_method :current_user, :all_states

  before_action :check_login
  
    private
  
    def check_login
        unless session[:user_id]
          redirect_to "/sessions/new"
        end
    end
end
