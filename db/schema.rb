# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_12_173459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "content"
    t.bigint "user_id", null: false
    t.string "token_channel"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token_channel"], name: "index_channels_on_token_channel", unique: true
    t.index ["user_id"], name: "index_channels_on_user_id"
  end

  create_table "podcast_bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "podcast_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_id"], name: "index_podcast_bookmarks_on_podcast_id"
    t.index ["user_id"], name: "index_podcast_bookmarks_on_user_id"
  end

  create_table "podcast_notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "podcast_id", null: false
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "viewed"
    t.index ["podcast_id"], name: "index_podcast_notifications_on_podcast_id"
    t.index ["user_id"], name: "index_podcast_notifications_on_user_id"
  end

  create_table "podcasthistories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "podcast_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "listens"
    t.index ["podcast_id"], name: "index_podcasthistories_on_podcast_id"
    t.index ["user_id"], name: "index_podcasthistories_on_user_id"
  end

  create_table "podcastreplies", force: :cascade do |t|
    t.string "comment"
    t.bigint "user_id", null: false
    t.bigint "podcomment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcomment_id"], name: "index_podcastreplies_on_podcomment_id"
    t.index ["user_id"], name: "index_podcastreplies_on_user_id"
  end

  create_table "podcasts", force: :cascade do |t|
    t.string "title"
    t.string "desciption"
    t.bigint "channel_id", null: false
    t.bigint "user_id", null: false
    t.string "token"
    t.boolean "suspended"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "listens"
    t.index ["channel_id"], name: "index_podcasts_on_channel_id"
    t.index ["token"], name: "index_podcasts_on_token", unique: true
    t.index ["user_id"], name: "index_podcasts_on_user_id"
  end

  create_table "podcomments", force: :cascade do |t|
    t.string "comment"
    t.bigint "user_id", null: false
    t.bigint "podcast_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_id"], name: "index_podcomments_on_podcast_id"
    t.index ["user_id"], name: "index_podcomments_on_user_id"
  end

  create_table "report_podcasts", force: :cascade do |t|
    t.string "report"
    t.bigint "user_id", null: false
    t.bigint "podcast_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_id"], name: "index_report_podcasts_on_podcast_id"
    t.index ["user_id"], name: "index_report_podcasts_on_user_id"
  end

  create_table "report_videos", force: :cascade do |t|
    t.string "report"
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_report_videos_on_user_id"
    t.index ["video_id"], name: "index_report_videos_on_video_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_subscriptions_on_channel_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "isAdmin"
    t.boolean "suspended"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  create_table "vidcomments", force: :cascade do |t|
    t.string "comment"
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_vidcomments_on_user_id"
    t.index ["video_id"], name: "index_vidcomments_on_video_id"
  end

  create_table "video_bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_video_bookmarks_on_user_id"
    t.index ["video_id"], name: "index_video_bookmarks_on_video_id"
  end

  create_table "video_notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "viewed"
    t.index ["user_id"], name: "index_video_notifications_on_user_id"
    t.index ["video_id"], name: "index_video_notifications_on_video_id"
  end

  create_table "videohistories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "viewed"
    t.index ["user_id"], name: "index_videohistories_on_user_id"
    t.index ["video_id"], name: "index_videohistories_on_video_id"
  end

  create_table "videoreplies", force: :cascade do |t|
    t.string "comment"
    t.bigint "user_id", null: false
    t.bigint "vidcomment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_videoreplies_on_user_id"
    t.index ["vidcomment_id"], name: "index_videoreplies_on_vidcomment_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.bigint "channel_id", null: false
    t.bigint "user_id", null: false
    t.boolean "suspended"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "views"
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["token"], name: "index_videos_on_token", unique: true
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "channels", "users"
  add_foreign_key "podcast_bookmarks", "podcasts"
  add_foreign_key "podcast_bookmarks", "users"
  add_foreign_key "podcast_notifications", "podcasts"
  add_foreign_key "podcast_notifications", "users"
  add_foreign_key "podcasthistories", "podcasts"
  add_foreign_key "podcasthistories", "users"
  add_foreign_key "podcastreplies", "podcomments"
  add_foreign_key "podcastreplies", "users"
  add_foreign_key "podcasts", "channels"
  add_foreign_key "podcasts", "users"
  add_foreign_key "podcomments", "podcasts"
  add_foreign_key "podcomments", "users"
  add_foreign_key "report_podcasts", "podcasts"
  add_foreign_key "report_podcasts", "users"
  add_foreign_key "report_videos", "users"
  add_foreign_key "report_videos", "videos"
  add_foreign_key "subscriptions", "channels"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "vidcomments", "users"
  add_foreign_key "vidcomments", "videos"
  add_foreign_key "video_bookmarks", "users"
  add_foreign_key "video_bookmarks", "videos"
  add_foreign_key "video_notifications", "users"
  add_foreign_key "video_notifications", "videos"
  add_foreign_key "videohistories", "users"
  add_foreign_key "videohistories", "videos"
  add_foreign_key "videoreplies", "users"
  add_foreign_key "videoreplies", "vidcomments"
  add_foreign_key "videos", "channels"
  add_foreign_key "videos", "users"
end
