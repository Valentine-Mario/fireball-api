class PodcastcommentController < ApplicationController
    before_action :authorize_request, except:[]
    before_action :getPodcast, only:[:addComment]
    before_action :getYourComment, only:[:deleteComment]
    before_action :getPodcastByToken, only:[:getCommentinPodcast]
    def addComment
        if @current_user.suspended == false
            @comment= Podcomment.new(postParam)
            @comment.user_id=@current_user.id
            @comment.podcast_id=@podcast.id
            if @comment.save
                render :json=>{code:"00", message:@comment}.to_json(:include=>[:user]), status: :ok
            else
                render :json=>{code:"01", message:"error creating comment"}, status: :unprocessable_entity
            end
        else
            render :json=>{code:"01", message:"account suspended"}, status: :unauthorized
        end
      
    end


    def deleteComment
        if @current_user.suspended==false
            for i in @comment.podcastreplies do
                i.destroy
            end
            @comment.destroy
            render :json=>{code:"00", message:"comment deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"account has been suspended"}, status: :unauthorized
        end
    end

    def getCommentinPodcast
        @comments= @podcast.podcomments.paginate(page: params[:page], per_page: params[:per_page])
        total=@comments.total_entries
        render :json=>{code:"00", message:@comments, total:total}.to_json(:include=>[:user, :podcastreplies ]), status: :ok
    end



    private

    def postParam
        params.permit(
            :comment
           )
    end

    def getPodcast
        @podcast= Podcast.find_by!(id: params[:id])
    end

    def getYourComment
        @comment= @current_user.podcomments.find_by!(id: params[:id]) if @current_user
    end

    def getPodcastByToken
        @podcast= Podcast.find_by_token!(params[:token])
    end
end
