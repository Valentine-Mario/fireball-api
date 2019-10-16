class DeletepodcastchannelJob < ApplicationJob
  queue_as :default

  def perform(post)
    # Do something later
    for i in post.podcasts do
      for j in i.podcomments do
        for k in j.podcastreplies 
          for l in i.podcast_bookmarks do
            l.destroy
          end
          k.destroy
        end
        j.destroy
      end
      i.pod.purge
      i.report_podcasts.destroy_all
      i.destroy
  end
    post.image.purge
    post.destroy
    Subscription.where(channel:post.id).destroy_all

  end
end
