class AddViewedToPodcastNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :podcast_notifications, :viewed, :boolean
  end
end
