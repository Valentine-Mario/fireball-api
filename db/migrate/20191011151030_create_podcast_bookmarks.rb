class CreatePodcastBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :podcast_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :podcast, null: false, foreign_key: true

      t.timestamps
    end
  end
end
