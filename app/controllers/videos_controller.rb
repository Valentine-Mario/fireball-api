class VideosController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only:[:createVideo, :editVideo, :deleteVideo, :getVideoByToken, :getViewHistory]
    before_action :getChannel, only:[:createVideo]
    before_action :findChannelByToken, only:[:getVideoInChannel]
    before_action :getVideo, only:[:editVideo, :deleteVideo, :getViewHistory]

    def createVideo
        if @current_user.suspended==false
            if @channel.content == 2
                @post=Video.new(postParam)
                @post.user_id=@current_user.id
                @post.channel_id=@channel.id
                if @post.save
                    render :json=>{code:"00", message:@post}, status: :ok
                else
                    render :json=>{code:"01", message:"error creating post"}, status: :unprocessable_entity
                end
            else
                render :json=>{code:"01", message:"only video allowed in this channel"}, status: :ok
            end
        else
            render :json=>{code:"01", message:"account has been suspended"}, status: :ok
        end
    end

    def getAllVideos
        @videos=Video.paginate(page: params[:page], per_page: params[:per_page]).where(suspended: false)
        total=@videos.total_entries
        render :json=>{code:"00", message:@videos, total:total}.to_json(:include=>[:channel]), status: :ok
    end


    def getVideoInChannel
        @videos=@channel.videos.paginate(page: params[:page], per_page: params[:per_page]).where(suspended: false)
        total=@videos.total_entries  
        render :json=>{code:"00", message:@videos, channel:@channel, total:total}, status: :ok
    end

    def editVideo
        if @current_user.suspended==false
           if @video.update(editParams)
                render :json=>{code:"00", message:"video update successul"}, status: :ok
           else
                render :json=>{code:"01", message:"error editing video"}, status: :unprocessable_entity
           end
        else
            render :json=>{code:"01", message:"account suspended"}, status: :unauthorized
        end
    end

    def deleteVideo
        if @current_user.suspended==false
            for i in @video.vidcomments do
                i.destroy
            end
            @video.vid.purge
            @video.destroy
            render :json=>{code:"00", message:"video deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"account suspended"}, status: :unauthorized
        end
    end

    def searchVideo
        @videos = Video.paginate(page: params[:page], per_page: params[:per_page]).where("title LIKE ? OR description LIKE ?", "%#{params[:any]}%", "%#{params[:any]}%").where(suspended: false).order("created_at DESC")
        @total=@videos.total_entries
        render :json=>{code:"00", message:@videos, total:@total}.to_json(:include=>[:channel]), status: :ok
    end


    def getVideoByToken
        @video= Video.find_by_token!(params[:token])
        if @video.suspended==false
            @video_history=Videohistory.where(user_id:@current_user.id, video_id:@video.id)
            if @video_history.length>0
                @video_history[0].increment!(:viewed, by=1)
            else
                @vid_history=@video.videohistories.create 
                @vid_history.user_id=@current_user.id
                @vid_history.save
            end
            vid_link=rails_blob_url(@video.vid)
            @video.increment!(:views, by=1)
            render :json=>{code:"00", message:@video, video:vid_link}.to_json(:include=>[:channel, :user]), status: :ok
        else
            render :json=>{code:"01", message:"this video has been suspended"}, status: :unauthorized
        end
    end
    

    def getViewHistory
        if @current_user.suspended==false
            history= @video.videohistories.paginate(page: params[:page], per_page: params[:per_page])
            total=history.total_entries
            render :json=>{code:"00", message:history, total:total}.to_json(:include=>[:user]), status: :ok
        else
            render :json=>{code:"01", message:"account suspended"}, status: :ok
        end
    end


    private

    def postParam
        params.permit(
            :title, :description, :vid
           )
    end

    def editParams
        params.permit(
            :title, :description
        )
    end


    def getChannel
        @channel = @current_user.channels.find_by!(id: params[:id]) if @current_user
      end


      def findChannelByToken
        @channel=Channel.find_by_token_channel(params[:token_channel])
    end

    def getVideo
        @video= @current_user.videos.find_by!(id: params[:id]) if @current_user
    end
end
