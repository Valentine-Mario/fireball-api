class CreateReportVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :report_videos do |t|
      t.string :report
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end
  end
end
