class CreateVideoreplies < ActiveRecord::Migration[6.0]
  def change
    create_table :videoreplies do |t|
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.references :vidcomment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
