class PodcastController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only:[:addPodcast, :editPodcast, :deletePodcast, :ListenToPodcast, :viewListenHistory, :PodcastFeed]
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
                    render :json=>{code:"01", message:"error creating post"}
                end
            else
                render :json=>{code:"01", message:"only podcast allowed in this channel"}, status: :ok
            end
        
       else
        render :json=>{code:"01", message:"account suspended. Unable to add podcast"}
       end
    end


    def getAllPodcast
        @podcasts=Podcast.paginate(page: params[:page], per_page: params[:per_page]).where(suspended: false)
        total=@podcasts.total_entries
        render :json=>{code:"00", message:@podcasts, total:total}.to_json(:include=>[:channel]), status: :ok
    end

    def getMostListens
        @podcast=Podcast.paginate(page: params[:page], per_page: params[:per_page]).where(suspended:false).order(views: :listens)
        total=@podcast.total_entries
        render :json=>{code:"00", message:@podcast, total:total}.to_json(:include=>[:channel]), status: :ok
    end

    def PodcastFeed
        @sub=Subscription.where(user_id: @current_user.id)
        sub_channel=@sub.map { |h| h[:channel_id] }
        @podcast=Podcast.paginate(page: params[:page], per_page: params[:per_page]).where(channel_id:sub_channel).order("created_at DESC")
        total=@podcast.total_entries
        render :json=>{code:"00", message:@podcast, total:total}.to_json(:include=>[:channel]), status: :ok
    end

    def getPodCastInChannel
        @podcast=@channel.podcasts.where(suspended: false)
        
        render :json=>{code:"00", message:@podcast, channel:@channel}, status: :ok
    end

    def editPodcast
        if @current_user.suspended==false
           if @podcast.update(editParams)
                render :json=>{code:"00", message:"podcast update successul"}, status: :ok
           else
                render :json=>{code:"01", message:"error editing modal"}
           end
        else
            render :json=>{code:"01", message:"account suspended"}
        end
    end

    def deletePodcast
        if @current_user.suspended==false
            
            DeletepodcastJob.perform_later(@podcast)
            render :json=>{code:"00", message:"podcast deletion processing"}, status: :ok
        else
            render :json=>{code:"01", message:"account suspended"}
        end
    end

    def ListenToPodcast
        #when user open podcast, it increment the podcast count and adds listen history to table. If histpry already exist, increment history count
       @podcasts= Podcast.find_by_token!(params[:token])
        if @podcasts.suspended==false
            @podcast_history=Podcasthistory.where(user_id:@current_user.id, podcast_id:@podcasts.id)
            if @podcast_history.length>0
                @podcast_history[0].increment!(:listens, by=1)
            else
                @pod_history=@podcasts.podcasthistories.create 
                @pod_history.user_id=@current_user.id
                @pod_history.save
            end
            @podcasts.increment!(:listens, by=1)
            pod=rails_blob_url(@podcasts.pod)
            @chanel=Channel.find_by!(id: @podcasts.channel_id)
            @channel_pics=rails_blob_url(@channel.image)
            render :json=>{code:"00", message:@podcasts, podcast:pod, channel_pics:@channel_pics}.to_json(:include=>[:channel, :user]), status: :ok 
        else
            render :json=>{code:"01", message:"podcast has been suspeded"}
        end
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


    def searchPodcast
        @podcasts = Podcast.paginate(page: params[:page], per_page: params[:per_page]).where("title LIKE ? OR desciption LIKE ?", "%#{params[:any]}%", "%#{params[:any]}%").where(suspended: false).order("created_at DESC")
        @total=@podcasts.total_entries
        render :json=>{code:"00", message:@podcasts, total:@total}.to_json(:include=>[:channel]), status: :ok
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
