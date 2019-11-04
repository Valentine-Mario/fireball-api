class BookmarkController < ApplicationController
    before_action :authorize_request
    before_action :findVideo, only:[:BookmarkVideo]
    before_action :findPodcast, only:[:BookmarkPodcast]
    before_action :getVideoByToken, only:[:checkVideoBookmark]
    before_action :getPodcatByToken, only:[:checkPodcastBookmark]
    before_action :currentUserVideo, only:[:removeVideoBookmark]
    before_action :currentUserPodcast, only:[:removedPodcastBookmark]

    def BookmarkVideo
        if @current_user.suspended==false
            @bookmark_check= VideoBookmark.where(user_id:@current_user.id, video_id:@video.id)
            if @bookmark_check.length>0
                @bookmark_check[0].destroy
                render :json=>{code:"00", message:"bookmark removed"}
            else
                @bookmark=@video.video_bookmarks.create
                @bookmark.user_id=@current_user.id
                if @bookmark.save
                    render :json=>{code:"00", message:"video bookmarked successfully"}, status: :ok
                else
                    render :json=>{code:"01", message:"error bookmarking video"}
                end
            end
        else
            render :json=>{code:"01", message:"account has been suspended"}, status: :unauthorized
        end
    end

    def BookmarkPodcast
        if @current_user.suspended==false
            @bookmark_check= PodcastBookmark.where(user_id:@current_user.id, podcast_id:@podcast.id)
            if @bookmark_check.length>0
                @bookmark_check[0].destroy
                render :json=>{code:"00", message:"bookmark removed"}
            else
                @bookmark=@podcast.podcast_bookmarks.create
                @bookmark.user_id=@current_user.id
                if @bookmark.save
                    render :json=>{code:"00", message:"podcast bookmarked successfully"}, status: :ok
                else
                    render :json=>{code:"01", message:"error bookmarking video"}
                end
            end
        else
            render :json=>{code:"01", message:"account has been suspended"}
        end
    end

    def UserVideoBookmarks
        @bookmarks=@current_user.video_bookmarks
        render :json=>{code:"00", message:@bookmarks}.to_json(:include=>[:video]), status: :ok
    end

    def UserPodcastBookmarks
        @bookmarks=@current_user.podcast_bookmarks
        render :json=>{code:"00", message:@bookmarks}.to_json(:include=>[:podcast]), status: :ok
    end

    def checkVideoBookmark
       @bookmark_true = VideoBookmark.where(user_id:@current_user.id, video_id:@video.id)
       if @bookmark_true.length>0
        render :json=>{code:"00", message:true}
       else
        render :json=>{code:"00", message:false}
       end
        
    end

    def checkPodcastBookmark
        @bookmark_true= PodcastBookmark.where(user_id:@current_user.id, podcast_id:@podcast.id)
            if @bookmark_true.length>0
                render :json=>{code:"00", message:true}
            else
                render :json=>{code:"00", message:false}
            end
    end

    def removeVideoBookmark
        @bookmark.destroy
        render :json=>{code:"00", message:"bookmark removed"}, status: :ok
    end

    def removedPodcastBookmark
        @bookmark.destroy
        render :json=>{code:"00", message:"bookmark removed"}, status: :ok
    end

    private
    def findVideo
        @video= Video.find_by!(id: params[:id])
    end

    def findPodcast
        @podcast=Podcast.find_by!(id:params[:id])
    end

    def getVideoByToken
        @video= Video.find_by_token!(params[:token])
    end

    def getPodcatByToken
        @podcast=Podcast.find_by_token!(params[:token])
    end

    def currentUserVideo
        @bookmark = @current_user.video_bookmarks.find_by!(id: params[:id]) if @current_user
    end

    def currentUserPodcast
        @bookmark = @current_user.podcast_bookmarks.find_by!(id: params[:id]) if @current_user
    end
end
