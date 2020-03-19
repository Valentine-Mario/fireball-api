class Admin::UploadsController < ApplicationController
    before_action :authorize_request
    before_action :getVideo, only:[:suspend_video, :unsuspend_video]
    before_action :getPodcast, only:[:suspend_podcast, :unsuspend_podcast]

    def suspend_video
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"only admin allowed to access this route"}
        else
            @video.update!(setTrue)
            render :json=>{code:"00", message:"video suspended successfully"}, status: :ok
        end
    end

    def unsuspend_video
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"only admin allowed to access this route"}
        else
            @video.update!(setFalse)
            render :json=>{code:"00", message:"video unsuspended successfully"}, status: :ok
        end
    end

    def getVideoByToken
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"only admin allowed to access this route"}
        else
            @video= Video.find_by_token!(params[:token])
            vid_link=rails_blob_url(@video.vid)
            render :json=>{code:"00", message:@video, video:vid_link}.to_json(:include=>[:channel, :user]), status: :ok
        end
    end

    def suspend_podcast
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"only admin allowed to access this route"}
        else
            @podcast.update!(setTrue)
            render :json=>{code:"00", message:"podcast suspended successfully"}, status: :ok
        end
    end

    def unsuspend_podcast
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"only admin allowed to access this route"}
        else
            @podcast.update!(setFalse)
            render :json=>{code:"00", message:"podcast unsuspended successfully"}, status: :ok
        end
    end

    def ListenToPodcast
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"only admin allowed to access this route"}
        else
            @podcasts= Podcast.find_by_token!(params[:token])
      
            pod=rails_blob_url(@podcasts.pod)
            @channel_pics=rails_blob_url(@channel.image)
            render :json=>{code:"00", message:@podcasts, podcast:pod}.to_json(:include=>[:channel, :user]), status: :ok 
        end
       
    end

    def getAllVideos
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"only admin allowed to access this route"}
        else
            @videos=Video.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
        total=@videos.total_entries
        render :json=>{code:"00", message:@videos, total:total}.to_json(:include=>[:channel, :user]), status: :ok
        end
    end

    def searchVideo
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"only admin allowed to access this route"}
        else
            @videos = Video.paginate(page: params[:page], per_page: params[:per_page]).where("lower(title) LIKE ? OR lower(description) LIKE ?", "%#{params[:any].downcase}%", "%#{params[:any].downcase}%").order("created_at DESC")
        @total=@videos.total_entries
        render :json=>{code:"00", message:@videos, total:@total}.to_json(:include=>[:channel, :user]), status: :ok
        end
    end

    def searchPodcast
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"only admin allowed to access this route"}
        else
            @podcasts = Podcast.paginate(page: params[:page], per_page: params[:per_page]).where("lower(title) LIKE ? OR lower(desciption) LIKE ?", "%#{params[:any].downcase}%", "%#{params[:any].downcase}%").order("created_at DESC")
        @total=@podcasts.total_entries
        render :json=>{code:"00", message:@podcasts, total:@total}.to_json(:include=>[:channel, :user]), status: :ok
        end
    end

    def getAllPodcast
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"only admin allowed to access this route"}
        else
            @podcasts=Podcast.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
        total=@podcasts.total_entries
        render :json=>{code:"00", message:@podcasts, total:total}.to_json(:include=>[:channel, :user]), status: :ok
        end
    end
    private
    def getVideo
        @video= Video.find_by!(id: params[:id])
    end

    def getPodcast
        @podcast= Podcast.find_by!(id: params[:id])
    end

    def setTrue
        defaults = { suspended: true }
        params.permit(:suspended).reverse_merge(defaults)
    end

    def setFalse
        defaults={suspended:false}
        params.permit(:suspended).reverse_merge(defaults)
    end
end
