class CommentsController < ApplicationController

    def create 
        # @comment = Comment.new(comment:params[:comment][:comment], user:current_user, event:Event.find(params[:comment][:event_id]))
        @comment = Comment.new comment_params_create
        if @comment.save
          redirect_to "/events"
        else
          flash[:errors] = @comment.errors.full_messages
          redirect_to "/events/#{params[:comment][:event_id]}"
        end
    end

    private
        def comment_params_create
            params.require(:comment).permit(:comment, :event_id).merge(user: current_user)
        end
end
