class CreateVideoBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :video_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end
  end
end
