class DeleteJob < ApplicationJob
  queue_as :default

  def perform(video)
    # Do something later
      for i in video.vidcomments do
        for j in i.videoreplies do
            j.destroy
        end
          i.destroy
       end
       Videohistory.where(video:video.id).destroy_all
       VideoBookmark.where(video:video.id).destroy_all
       VideoNotification.where(video:video.id).destroy_all
       ReportVideo.where(video:video.id).destroy_all
        video.vid.purge
        video.destroy
  end
end
