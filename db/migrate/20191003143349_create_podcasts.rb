class CreatePodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :podcasts do |t|
      t.string :title
      t.string :desciption
      t.references :channel, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.boolean :suspended

      t.timestamps
    end
    add_index :podcasts, :token, unique: true
  end
end
