# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_28_075313) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "booths", force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "track_id"
    t.integer "dj_id"
    t.datetime "start_time", precision: nil
    t.index ["dj_id"], name: "index_booths_on_dj_id"
    t.index ["owner_id"], name: "index_booths_on_owner_id"
    t.index ["track_id"], name: "index_booths_on_track_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "provider_id"
    t.json "provider_info"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "provider_id"], name: "index_identities_on_provider_and_provider_id", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "track_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_playlist_tracks_on_playlist_id"
    t.index ["track_id"], name: "index_playlist_tracks_on_track_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "position", default: 0
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "plays", force: :cascade do |t|
    t.integer "track_id"
    t.integer "booth_id"
    t.integer "user_id"
    t.integer "woots_count"
    t.integer "grabs_count"
    t.integer "mehs_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booth_id"], name: "index_plays_on_booth_id"
    t.index ["track_id"], name: "index_plays_on_track_id"
    t.index ["user_id"], name: "index_plays_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.string "uploader"
    t.integer "duration"
    t.string "service"
    t.string "service_id"
    t.string "thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service", "service_id"], name: "index_tracks_on_service_and_service_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_playlist_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "waitlists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "booth_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booth_id"], name: "index_waitlists_on_booth_id"
    t.index ["created_at"], name: "index_waitlists_on_created_at"
    t.index ["user_id"], name: "index_waitlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
