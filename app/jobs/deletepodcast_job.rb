class DeletepodcastJob < ApplicationJob
  queue_as :default

  def perform(podcast)
    # Do something later
    for i in podcast.podcomments do
      for j in i.podcastreplies do
          j.destroy
      end
      i.destroy
  end
  PodcastBookmark.where(podcast:podcast.id).destroy_all
  Podcasthistory.where(podcast:podcast.id).destroy_all
  PodcastNotification.where(podcast:podcast.id).destroy_all
  ReportPodcast.where(podcast:podcast.id).destroy_all
  podcast.pod.purge
  podcast.destroy
  end
end
