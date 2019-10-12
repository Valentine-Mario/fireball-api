class AddViewedToVideoNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :video_notifications, :viewed, :boolean
  end
end
