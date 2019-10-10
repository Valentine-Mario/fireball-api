class CreateReportPodcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :report_podcasts do |t|
      t.string :report
      t.references :user, null: false, foreign_key: true
      t.references :podcast, null: false, foreign_key: true

      t.timestamps
    end
  end
end
