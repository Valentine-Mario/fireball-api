class ReportController < ApplicationController
    before_action :authorize_request
    before_action :getVideo, only:[:reportVideo]
    before_action :getPodcast, only:[:reportPodcast]


    def reportVideo
        if @current_user.suspended == false
           @report= @current_user.report_videos.create(postParams)
           @report.video_id=@video.id
           if @report.save
            render :json=>{code:"00", message:"report sent successfully. Thank you"}, status: :ok
           else
            render :json=>{code:"01", message:"error sending report"}
           end
        else
            render :json=>{code:"01", message:"account has been suspended"}
        end
    end

    def reportPodcast
        if @current_user.suspended == false
            @report= @current_user.report_podcasts.create(postParams)
            @report.podcast_id=@podcast.id
            if @report.save
             render :json=>{code:"00", message:"report sent successfully. Thank you"}, status: :ok
            else
             render :json=>{code:"01", message:"error sending report"}
            end
         else
             render :json=>{code:"01", message:"account has been suspended"}
         end
    end


    private
    def postParams
        params.permit(
            :report
           )
    end

    def getVideo
        @video= Video.find_by!(id: params[:id])
    end

    def getPodcast
        @podcast= Podcast.find_by!(id: params[:id])
    end
end
