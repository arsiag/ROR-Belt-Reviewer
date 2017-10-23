class EventsController < ApplicationController

  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @user = current_user
    # @events = current_user.state.events
    @events = Event.all.where("state_id = ?", @user.state_id).distinct
    
    # @others = Event.joins(:user).where("events.state_id != ?", current_user.state_id)
    @others = Event.all.where("state_id != ?", @user.state_id).distinct
  end

  def create 
    @event = Event.new event_params_create
    if @event.save
      redirect_to "/events"
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to "/events"
    end
  end 

  def show
    @event = Event.find(params[:id])
    @host = @event.user
    @users = @event.joined_users
    @comments = @event.comments
  end

  def edit 
    @event = Event.find(params[:id])
  end 

  def update 
    @event = Event.find(params[:id])
    if @event.update event_params_update
      redirect_to "/events"
    else
      flash[:errors] = @event.errors.full_messages     
      redirect_to "/events/#{params[:id]}/edit"
    end
  end 

  def destroy 
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to "/events" 
  end 

  def join 
    @join = current_user.joins.find_by(event_id:params[:id])
    if not @join
      Join.create(user_id: current_user.id, event_id: params[:id])
    end
    redirect_to "/events"
  end

  def cancel 
    @join = current_user.joins.find_by(event_id:params[:id])
    if @join
      @join.destroy
    end
    redirect_to "/events"
  end

  private
    def event_params_create
      params.require(:event).permit(:name, :event_date, :location, :state_id).merge(user: current_user)
    end

    def event_params_update
      params.require(:event).permit(:name,:event_date,:location,:state_id)  	
    end

    def check_user
      if current_user != Event.find(params[:id]).user
        redirect_to "/events" 
      end
    end
end
