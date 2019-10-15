class Admin::ReportsController < ApplicationController
    before_action :authorize_request
    before_action :getVideo, only:[:getVideoReport]
    before_action :getPodcast, only:[:getPodcastReport]


    def getVideoReport
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"only admin allowed to access this route"}, staus: :unauthorised    
        else
            reports=@video.report_videos.paginate(page: params[:page], per_page: params[:per_page])
            total=reports.total_entries
            render :json=>{code:"00", message:reports, total:total}.to_json(:include=>[:user]), staus: :ok
        end
        
    end

    def getPodcastReport
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"only admin allowed to access this route"}, staus: :unauthorised
        else
            reports=@podcast.report_podcasts.paginate(page: params[:page], per_page: params[:per_page])
            total=reports.total_entries
            render :json=>{code:"00", message:reports, total:total}.to_json(:include=>[:user]), staus: :ok
        end
    end

    private
    def getVideo
        @video= Video.find_by_token!(params[:token])
    end

    def getPodcast
        @podcast= Podcast.find_by_token!(params[:token])
    end
end
