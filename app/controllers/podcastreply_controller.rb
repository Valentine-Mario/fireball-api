class PodcastreplyController < ApplicationController
    before_action :authorize_request, except:[]
    before_action :getPodcast, only:[:replyTocomment]
    before_action :getYourReply, only:[:deleteReply]

    def replyTocomment
        if @current_user.suspended == false
            @reply=@comment.podcastreplies.create(postParams)
            @reply.user_id=@current_user.id
            if @reply.save
                render :json=>{code:"00", message:@reply}.to_json(:include=>[:user]), status: :ok
                if @current_user.id == @comment.user_id
                    #do nothing
                else
                    @podcast_notif= PodcastNotification.new()
                    @podcast_notif.user_id=@comment.user_id
                    @podcast_notif.podcast_id=@comment.podcast_id
                    @podcast_notif.message=@current_user.name+" replied to your comment"
                    @podcast_notif.save
                end
            else
                render :json=>{code:"01", message:"error creating comment"}, status: :unprocessable_entity
            end
        else
            render :json=>{code:"01", message:"account has been suspended"}, status: :unauthorized
        end
    end

    def deleteReply
        if @current_user.suspended==false
            @reply.destroy
            render :json=>{code:"00", message:"comment deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"account has been suspended"}, status: :unauthorized
        end
    end


    private
    def postParams
        params.permit(
            :comment
           )
    end

    def getPodcast
        @comment= Podcomment.find_by!(id: params[:id])
    end

    def getYourReply
        @reply= @current_user.podcastreplies.find_by!(id: params[:id]) if @current_user
    end
end
