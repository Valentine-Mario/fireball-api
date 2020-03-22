class VideoreplyController < ApplicationController
    before_action :authorize_request, except:[]
    before_action :getVideo, only:[:replyTocomment]
    before_action :getYourReply, only:[:deleteReply]

    def replyTocomment
        if @current_user.suspended == false
            @reply=@comment.videoreplies.create(postParams)
            @reply.user_id=@current_user.id
            if @reply.save
                render :json=>{code:"00", message:@reply}.to_json(:include=>[:user]), status: :ok
                if @current_user.id == @comment.user_id
                    #do nothing
                else
                    @video_notif= VideoNotification.new()
                    @video_notif.user_id=@comment.user_id
                    @video_notif.video_id=@comment.video_id
                    @video_notif.message=@current_user.name+" replied to your comment"
                    @video_notif.save
                end
            else
                render :json=>{code:"01", message:"error creating comment"}
            end
        else
            render :json=>{code:"01", message:"account has been suspended"}
        end
    end

    def deleteReply
        if @current_user.suspended==false
            @reply.destroy
            render :json=>{code:"00", message:"comment deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"account has been suspended"}
        end
    end


    private
    def postParams
        params.permit(
            :comment
           )
    end

    def getVideo
        @comment= Vidcomment.find_by!(id: params[:id])
    end

    def getYourReply
        @reply= @current_user.videoreplies.find_by!(id: params[:id]) if @current_user
    end
end
