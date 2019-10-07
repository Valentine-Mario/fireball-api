class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.references :channel, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :suspended
      t.string :token

      t.timestamps
    end
    add_index :videos, :token, unique: true
  end
end
