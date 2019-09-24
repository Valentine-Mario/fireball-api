class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :pics
      t.string :password_digest
      t.boolean :isAdmin
      t.boolean :suspended

      t.timestamps
    end
  end
end
