class AddViewedToVideohistories < ActiveRecord::Migration[6.0]
  def change
    add_column :videohistories, :viewed, :integer
  end
end
