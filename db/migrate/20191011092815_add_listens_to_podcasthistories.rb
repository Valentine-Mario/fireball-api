class AddListensToPodcasthistories < ActiveRecord::Migration[6.0]
  def change
    add_column :podcasthistories, :listens, :integer
  end
end
