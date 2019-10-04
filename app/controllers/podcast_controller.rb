class PodcastController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only:[:addPodcast, :editPodcast, :deletePodcast, :ListenToPodcast, :viewListenHistory]
    before_action :getChannel, only:[:addPodcast]
    before_action :findChannelByToken, only:[:getPodCastInChannel]
    before_action :getPodcast, only:[:editPodcast, :deletePodcast, :viewListenHistory]

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

    def getAllPodcast
        @podcasts=Podcast.paginate(page: params[:page], per_page: params[:per_page]).where(suspended: false)
        total=@podcasts.total_entries
        render :json=>{code:"00", message:@podcasts, total:total}.to_json(:include=>[:channel]), status: :ok
    end

    def getPodCastInChannel
        @podcast=@channel.podcasts.paginate(page: params[:page], per_page: params[:per_page])
        total=@podcast.total_entries
        
        render :json=>{code:"00", message:@podcast, channel:@channel, total:total}, status: :ok
    end

    def editPodcast
        if @current_user.suspended==false
           if @podcast.update(editParams)
                render :json=>{code:"00", message:"podcast update successul"}, status: :ok
           else
                render :json=>{code:"01", message:"error editing modal"}, status: :unprocessable_entity
           end
        else
            render :json=>{code:"01", message:"account suspended"}, status: :unauthorized
        end
    end

    def deletePodcast
        if @current_user.suspended==false
            @podcast.pod.purge
            render :json=>{code:"00", message:"podcast deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"account suspended"}, status: :unauthorized
        end
    end

    def ListenToPodcast
       @podcasts= Podcast.find_by_token!(params[:token])
       @pod_history=@podcasts.podcasthistories.create 
       @pod_history.user_id=@current_user.id
       @pod_history.save
       pod=rails_blob_url(@podcasts.pod)
       render :json=>{code:"00", message:@podcasts, podcast:pod, listens:@podcasts.podcasthistories.length}.to_json(:include=>[:channel, :user]), status: :ok
    end

    def viewListenHistory
        if @current_user.suspended==false
            history= @podcast.podcasthistories.paginate(page: params[:page], per_page: params[:per_page])
            total=history.total_entries
            render :json=>{code:"00", message:history, total:total}.to_json(:include=>[:user]), status: :ok
        else
            render :json=>{code:"01", message:"account suspended"}, status: :ok
        end
    end
    

    private

    def postParam
        params.permit(
            :title, :desciption, :pod
           )
    end

    def editParams
        params.permit(
            :title, :desciption
        )
    end
    def findChannelByToken
        @channel=Channel.find_by_token_channel(params[:token_channel])
    end
    def getChannel
        @channel = @current_user.channels.find_by!(id: params[:id]) if @current_user
      end

      def getPodcast
          @podcast= @current_user.podcasts.find_by!(id: params[:id]) if @current_user
      end
end
