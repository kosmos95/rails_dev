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

ActiveRecord::Schema.define(version: 2023_08_23_071317) do

  create_table "_postspaging_g0_b10_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b11_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b14_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b16_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b24_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b5_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b65_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b6_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b75_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b7_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b82_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g0_b9_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g2_b0_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g3_b0_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "_postspaging_g4_b0_k_ogid_r20_n0", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", limit: 32, default: "", null: false
    t.string "encrypted_password", limit: 100, default: "", null: false
    t.string "reset_password_token", limit: 100
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "board_groups", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "bgid", limit: 16, null: false
    t.string "name", limit: 32
    t.string "short_name", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bgid"], name: "index_board_groups_on_bgid", unique: true
  end

  create_table "boards", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "bid", limit: 16
    t.string "name", limit: 32
    t.string "short_name", limit: 10
    t.string "category", limit: 191
    t.integer "board_group_id"
    t.integer "display", limit: 1, default: 1, null: false
    t.integer "hidden", limit: 1, default: 0, null: false
    t.integer "arrange", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minlevel_index", limit: 1, default: 0
    t.integer "minlevel_show", limit: 1, default: 0
    t.integer "minlevel_create", limit: 1, default: 1
    t.integer "minlevel_download", limit: 1, default: 0
    t.index ["bid"], name: "index_boards_on_bid", unique: true
    t.index ["board_group_id"], name: "index_boards_on_board_group_id"
    t.index ["display"], name: "display"
    t.index ["hidden"], name: "hidden"
  end

  create_table "comment_favors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "comment_id"
    t.integer "favored_user_id"
    t.index ["comment_id"], name: "index_comment_favors_on_comment_id"
    t.index ["favored_user_id"], name: "index_comment_favors_on_favored_user_id"
  end

  create_table "comments", primary_key: ["id", "board_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", options: "ENGINE=InnoDB\n/*!50100 PARTITION BY HASH (`board_id`)\nPARTITIONS 300 */", force: :cascade do |t|
    t.integer "id", null: false, auto_increment: true
    t.integer "gid"
    t.integer "board_id", null: false
    t.integer "parent_id", default: 0, null: false
    t.string "reply_order", limit: 20, default: "", null: false
    t.string "name", limit: 32, default: "", null: false
    t.string "nick", limit: 32, default: "", null: false
    t.text "content"
    t.string "image"
    t.integer "img_pos", default: 0, null: false
    t.string "html", limit: 4, default: "html", null: false
    t.string "ip", limit: 25, default: "", null: false
    t.integer "user_id"
    t.integer "post_id"
    t.integer "score1", default: 0, null: false
    t.integer "score2", default: 0, null: false
    t.integer "report_cnt", default: 0, null: false
    t.integer "favor_cnt", default: 0, null: false
    t.integer "unfavor_cnt", default: 0, null: false
    t.integer "deleted", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_comments_on_board_id"
    t.index ["deleted"], name: "index_comments_on_deleted"
    t.index ["gid"], name: "index_comments_on_gid"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "custom_fields", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "object_class"
    t.string "name"
    t.string "slug"
    t.integer "objectid"
    t.integer "parent_id"
    t.integer "field_order"
    t.integer "count", default: 0
    t.boolean "is_repeat", default: false
    t.text "description"
    t.string "status"
    t.index ["object_class"], name: "index_custom_fields_on_object_class"
    t.index ["objectid"], name: "index_custom_fields_on_objectid"
    t.index ["parent_id"], name: "index_custom_fields_on_parent_id"
    t.index ["slug"], name: "index_custom_fields_on_slug"
  end

  create_table "custom_fields_relationships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "objectid"
    t.integer "custom_field_id"
    t.integer "term_order"
    t.string "object_class"
    t.text "value", size: :long
    t.string "custom_field_slug"
    t.index ["custom_field_id"], name: "index_custom_fields_relationships_on_custom_field_id"
    t.index ["custom_field_slug"], name: "index_custom_fields_relationships_on_custom_field_slug"
    t.index ["object_class"], name: "index_custom_fields_relationships_on_object_class"
    t.index ["objectid"], name: "index_custom_fields_relationships_on_objectid"
  end

  create_table "exceptions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "class_name"
    t.text "status"
    t.text "message"
    t.text "trace"
    t.text "target"
    t.text "referrer"
    t.text "params"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fansite_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fansite_id"
    t.bigint "user_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fansite_id"], name: "index_fansite_comments_on_fansite_id"
    t.index ["user_id"], name: "index_fansite_comments_on_user_id"
  end

  create_table "fansites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "site_type"
    t.string "country"
    t.text "image"
    t.string "url1"
    t.string "url2"
    t.string "url3"
    t.text "description"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country"], name: "index_fansites_on_country"
    t.index ["site_type"], name: "index_fansites_on_site_type"
    t.index ["user_id"], name: "index_fansites_on_user_id"
  end

  create_table "hanuris", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "country"
    t.string "url1"
    t.string "url2"
    t.string "url3"
    t.string "image"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_info"
    t.text "sns_urls"
    t.boolean "hidden", default: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_hanuris_on_user_id"
  end

  create_table "identities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "alt"
    t.integer "hint", default: 0
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hint"], name: "index_images_on_hint"
  end

  create_table "levels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "site_id"
    t.integer "level"
    t.string "name", limit: 32
    t.boolean "enable_autoupgrade", default: false, null: false
    t.integer "autoupgrade_login_num", default: 0, null: false
    t.integer "autoupgrade_post_num", default: 0, null: false
    t.integer "autoupgrade_comment_num", default: 0, null: false
    t.integer "autoupgrade_visit_days", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lv_scrap_books", id: { type: :integer, unsigned: true }, charset: "utf8mb3", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "bbsid", null: false
    t.string "name", null: false
    t.string "categories", null: false
    t.timestamp "created_at", null: false
    t.timestamp "updated_at", null: false
    t.index ["bbsid"], name: "boards_bbsid_unique", unique: true
  end

  create_table "lv_scraps", id: :integer, charset: "utf8mb3", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "date", limit: 10
    t.string "title"
    t.text "content"
    t.text "content_text"
    t.text "orig_content"
    t.integer "point"
    t.string "medium", limit: 50
    t.string "keywords"
    t.string "slug", limit: 50, null: false
    t.string "original_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "image_saved_at"
    t.index ["slug"], name: "slug", unique: true
  end

  create_table "menu_items", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "parent_id"
    t.string "url"
    t.string "target", limit: 16
    t.string "type", limit: 16
    t.integer "ordering"
    t.integer "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 32
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "site_id"
    t.index ["name"], name: "index_menus_on_name", unique: true
    t.index ["site_id"], name: "index_menus_on_site_id"
  end

  create_table "metas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key"
    t.text "value", size: :long
    t.integer "objectid"
    t.string "object_class"
    t.index ["key"], name: "index_metas_on_key", length: 191
    t.index ["object_class"], name: "index_metas_on_object_class", length: 191
    t.index ["objectid"], name: "index_metas_on_objectid"
  end

  create_table "new_menus", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "point_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "by_user_id", default: 0, null: false
    t.integer "point", default: 0, null: false
    t.string "reason"
    t.datetime "created_at"
    t.index ["user_id"], name: "index_point_logs_on_user_id"
  end

  create_table "post_favors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "post_id"
    t.integer "favored_user_id"
    t.index ["favored_user_id"], name: "index_post_favors_on_favored_user_id"
    t.index ["post_id"], name: "index_post_favors_on_post_id"
  end

  create_table "post_indices", primary_key: "post_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "gid", limit: 53, default: 0.0, null: false
    t.integer "board_id", null: false
    t.integer "board_group_id", default: 0, null: false
    t.integer "user_id"
    t.integer "site_id", null: false
    t.integer "notice", limit: 1, default: 0, null: false
    t.string "category", limit: 30
    t.boolean "deleted", default: false, null: false
    t.index ["board_group_id"], name: "index_post_indices_on_board_group_id"
    t.index ["board_id"], name: "index_post_indices_on_board_id"
    t.index ["category"], name: "category"
    t.index ["deleted"], name: "index_post_indices_on_deleted"
    t.index ["gid"], name: "index_post_indices_on_gid"
    t.index ["notice"], name: "index_post_indices_on_notice"
    t.index ["post_id"], name: "index_post_indices_on_post_id"
    t.index ["site_id"], name: "index_post_indices_on_site_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "posts", primary_key: ["id", "board_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", options: "ENGINE=InnoDB\n/*!50100 PARTITION BY HASH (`board_id`)\nPARTITIONS 300 */", force: :cascade do |t|
    t.integer "id", null: false, auto_increment: true
    t.float "gid", limit: 53, default: 0.0, null: false
    t.integer "board_group_id", default: 0, null: false
    t.integer "board_id", null: false
    t.string "bid", limit: 16, default: ""
    t.integer "site_id", limit: 1, default: 0, null: false
    t.integer "display", limit: 1, default: 1, null: false
    t.integer "hidden", limit: 1, default: 0, null: false
    t.integer "notice", limit: 1, default: 0, null: false
    t.integer "depth", limit: 1, default: 0, null: false
    t.integer "user_id"
    t.string "name", limit: 32
    t.string "nick", limit: 32
    t.string "subject", limit: 100
    t.string "category", limit: 32
    t.string "html", limit: 4, default: "html", null: false
    t.text "content", size: :medium, null: false
    t.string "tag", limit: 191
    t.string "files", limit: 191
    t.integer "files_cnt", default: 0, null: false
    t.string "source", limit: 191
    t.integer "hit", default: 0, null: false
    t.integer "favor_cnt", default: 0, null: false
    t.integer "unfavor_cnt", default: 0, null: false
    t.integer "comment_cnt", default: 0, null: false
    t.integer "report_cnt", default: 0, null: false
    t.string "ip", limit: 25, default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bid"], name: "index_posts_on_bid"
    t.index ["board_group_id"], name: "index_posts_on_board_group_id"
    t.index ["board_id"], name: "index_posts_on_board_id"
    t.index ["deleted"], name: "index_posts_on_deleted"
    t.index ["display"], name: "index_posts_on_display"
    t.index ["gid"], name: "index_posts_on_gid"
    t.index ["hidden"], name: "index_posts_on_hidden"
    t.index ["notice"], name: "index_posts_on_notice"
    t.index ["site_id"], name: "site_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "reportabuses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "target_type", default: 0, null: false
    t.integer "target_id"
    t.string "reason", limit: 100
    t.integer "action_type"
    t.string "memo", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 32
    t.string "resource_type", limit: 191
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "secure_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_secure_tokens_on_user_id", unique: true
  end

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "var", limit: 32, null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "sites", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 32
    t.string "slug", limit: 191
    t.string "description", limit: 191
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sph_counter", primary_key: "counter_id", id: :integer, default: nil, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "max_doc_id", null: false
  end

  create_table "taggings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type", limit: 32
    t.integer "taggable_id"
    t.string "tagger_type", limit: 32
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "term_relationships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "objectid"
    t.integer "term_order"
    t.bigint "term_taxonomy_id"
    t.index ["objectid"], name: "index_term_relationships_on_objectid"
    t.index ["term_order"], name: "index_term_relationships_on_term_order"
    t.index ["term_taxonomy_id"], name: "index_term_relationships_on_term_taxonomy_id"
  end

  create_table "term_taxonomy", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "taxonomy"
    t.text "description", size: :long
    t.integer "parent_id"
    t.integer "count"
    t.string "name"
    t.string "slug"
    t.integer "term_group"
    t.integer "term_order"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_term_taxonomy_on_parent_id"
    t.index ["slug"], name: "index_term_taxonomy_on_slug"
    t.index ["taxonomy"], name: "index_term_taxonomy_on_taxonomy"
    t.index ["term_order"], name: "index_term_taxonomy_on_term_order"
  end

  create_table "user_data", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "mailing", default: true, null: false
    t.integer "point"
    t.string "avatar"
    t.string "note"
    t.integer "lvl_login_cnt", default: 0
    t.integer "lvl_post_cnt", default: 0
    t.integer "lvl_comment_cnt", default: 0
    t.integer "lvl_visit_days", default: 0
    t.integer "total_post_cnt", default: 0
    t.integer "total_cmt_cnt", default: 0
    t.index ["user_id"], name: "index_user_data_on_user_id"
  end

  create_table "user_groups", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 32
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "success", default: true, null: false
    t.string "event_name", limit: 16
    t.string "reason", limit: 100
    t.string "ip", limit: 16
    t.string "useragent", limit: 100
    t.string "url", limit: 100
    t.string "referer", limit: 100
    t.datetime "created_at"
    t.index ["user_id"], name: "index_user_logs_on_user_id"
  end

  create_table "users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", limit: 32, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nick", limit: 32, default: "", null: false
    t.string "name", limit: 32, default: "", null: false
    t.integer "level", default: 1
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 25
    t.string "last_sign_in_ip", limit: 25
    t.string "confirmation_token", limit: 100
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 32
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token", limit: 100
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "roles_mask"
    t.boolean "stopped", default: false
    t.datetime "stopped_at"
    t.boolean "exclude_autoupgrade", default: false
    t.datetime "deleted_at"
    t.integer "user_group_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, length: 100
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["user_group_id"], name: "index_users_on_user_group_id"
  end

  create_table "users_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
