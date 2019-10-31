class VideocommentController < ApplicationController
    before_action :authorize_request, except:[]
    before_action :getVideo, only:[:addComment]
    before_action :getYourComment, only:[:deleteComment]
    before_action :getVideoByToken, only:[:getCommentinVideo]

    def addComment
        if @current_user.suspended == false
            @comment= Vidcomment.new(postParam)
            @comment.user_id=@current_user.id
            @comment.video_id=@video.id
           
            if @comment.save
                render :json=>{code:"00", message:@comment}.to_json(:include=>[:user]), status: :ok
                if @current_user.id == @video.user_id
                    #do nothing
                else
                     @video_notif= VideoNotification.new()
                     @video_notif.user_id=@video.user_id
                     @video_notif.video_id=@video.id
                     @video_notif.message=@current_user.name+" commented on your video"
                     @video_notif.save
                end
            else
                render :json=>{code:"01", message:"error creating comment"}, status: :unprocessable_entity
            end
        else
            render :json=>{code:"01", message:"account suspended"}, status: :unauthorized
        end
    end

    def deleteComment
        if @current_user.suspended==false
            for i in @comment.videoreplies do
                i.destroy
            end
            @comment.destroy
            render :json=>{code:"00", message:"comment deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"account has been suspended"}, status: :unauthorized
        end
    end

    def getCommentinVideo
        @comments= @video.vidcomments.paginate(page: params[:page], per_page: params[:per_page])
        total=@comments.total_entries
        render :json=>{code:"00", message:@comments, total:total}.to_json(:include=>{:user=>{},  :videoreplies=>{include: :user}}), status: :ok
    end

    private
    def postParam
        params.permit(
            :comment
           )
    end

    def getVideo
        @video= Video.find_by!(id: params[:id])
    end

    def getYourComment
        @comment= @current_user.vidcomments.find_by!(id: params[:id]) if @current_user
    end

    def getVideoByToken
        @video= Video.find_by_token!(params[:token])
    end
end
