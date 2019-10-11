class AddViewsToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :views, :integer
  end
end
