class DeletevideochannelJob < ApplicationJob
  queue_as :default

  def perform(post)
    # Do something 
    for i in post.videos do
        for j in i.vidcomments do
          for k in j.videoreplies do
              for l in i.video_bookmarks do
                l.destroy
              end
            k.destroy
          end
          j.destroy
        end
      i.vid.purge
      i.report_videos.destroy_all
      i.destroy
  end
    post.image.purge
    post.destroy
    Subscription.where(channel:post.id).destroy_all
  end
end
