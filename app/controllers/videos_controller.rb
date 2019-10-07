class VideosController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only:[:createVideo, :editVideo, :deleteVideo]
    before_action :getChannel, only:[:createVideo]
    before_action :findChannelByToken, only:[:getVideoInChannel]
    before_action :getVideo, only:[:editVideo, :deleteVideo]

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
    # def getVid
    #     @vid=Video.find_by(id:params[:id])
    #     vid_img=rails_blob_url(@vid.vid)
    #     render :json=>{message:@vid, pics:vid_img}
    # end


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
