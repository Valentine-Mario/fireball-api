class CreatePodcastreplies < ActiveRecord::Migration[6.0]
  def change
    create_table :podcastreplies do |t|
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.references :podcomment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
