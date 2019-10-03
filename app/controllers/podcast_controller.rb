class PodcastController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only:[:addPodcast]
    before_action :getChannel, only:[:addPodcast]

    def addPodcast
       if @current_user.suspended==false
            if @channel.content == 1
                @post=Podcast.new(postParam)
                @post.user_id=@current_user.id
                @post.channel_id=@channel.id
                if @post.save
                    render :json=>{code:"00", message:@post}, status: :ok
                else
                    render :json=>{code:"01", message:"error creating post"}, status: :unprocessable_entity
                end
            else
                render :json=>{code:"01", message:"only podcast allowed here"}, status: :ok
            end
        
       else
        render :json=>{code:"01", message:"account suspended. Unable to add podcast"}, status: :unauthorized
       end
    end

    def getPod
        @pod=Podcast.find(params[:id])
        pod= rails_blob_url(@pod.pod)
        render :json=>{mess:@pod, pod:pod}
    end

    private

    def postParam
        params.permit(
            :title, :desciption, :pod
           )
    end
    def getChannel
        @channel = @current_user.channels.find_by!(id: params[:id]) if @current_user
      end
end
