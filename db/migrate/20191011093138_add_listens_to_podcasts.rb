class AddListensToPodcasts < ActiveRecord::Migration[6.0]
  def change
    add_column :podcasts, :listens, :integer
  end
end
