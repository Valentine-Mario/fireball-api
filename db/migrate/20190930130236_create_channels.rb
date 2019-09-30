class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :name
      t.string :description
      t.integer :content
      t.references :user, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
    add_index :channels, :token, unique: true
  end
end
