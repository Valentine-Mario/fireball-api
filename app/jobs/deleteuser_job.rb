class DeleteuserJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Do something later
    for i in user.channels do
      if i.content==1
          for p in i.podcasts do
            for j in p.podcomments do
              for k in j.podcastreplies do
                for l in p.podcast_bookmarks do
                  l.destroy
                end
                k.destroy
              end
              j.destroy
            end
            p.pod.purge
            p.report_podcasts.destroy_all
            p.destroy
        end
        i.image.purge
        i.destroy
        Subscription.where(channel:i.id).destroy_all
      elsif i.content==2
        for q in i.videos do
          for j in q.vidcomments do
            for k in j.videoreplies do
              for l in q.video_bookmarks do
                l.destroy
              end
              k.destroy
            end
            j.destroy
          end
        q.vid.purge
        q.report_videos.destroy_all
        q.destroy
    end
      i.image.purge
      i.destroy
      Subscription.where(channel:i.id).destroy_all
      end
    end


    for i in user.vidcomments do
      i.videoreplies.destroy_all
      i.destroy
    end

    for i in user.podcomments do
      i.podcastreplies.destroy_all
      i.destroy
    end

    user.video_bookmarks.destroy_all
    user.podcastreplies.destroy_all
    
    PodcastBookmark.where(user:user.id).destroy_all
    Subscription.where(user:user.id).destroy_all
    ReportPodcast.where(user:user.id).destroy_all
    ReportVideo.where(user:user.id).destroy_all
    Podcasthistory.where(user:user.id).destroy_all
    Videohistory.where(user:user.id).destroy_all
    user.avatar.purge
    user.destroy
  end
end
