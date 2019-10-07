class VideosController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only:[:createVideo]
    before_action :getChannel, only:[:createVideo]

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
    def getChannel
        @channel = @current_user.channels.find_by!(id: params[:id]) if @current_user
      end
end
