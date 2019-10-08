class CreatePodcomments < ActiveRecord::Migration[6.0]
  def change
    create_table :podcomments do |t|
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.references :podcast, null: false, foreign_key: true

      t.timestamps
    end
  end
end
