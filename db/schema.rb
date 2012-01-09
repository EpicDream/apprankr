# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120108184833) do

  create_table "application_categories", :force => true do |t|
    t.integer  "application_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_downloads", :force => true do |t|
    t.integer  "application_id"
    t.integer  "download_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", :force => true do |t|
    t.string   "package"
    t.string   "developer"
    t.string   "website"
    t.string   "email"
    t.string   "icon"
    t.string   "video"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "screenshots"
    t.boolean  "monitor",     :default => false, :null => false
    t.integer  "category_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", :force => true do |t|
    t.integer  "application_id"
    t.integer  "language_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "application_id"
  end

  create_table "languages", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "scrape",     :default => false
  end

  create_table "prices", :force => true do |t|
    t.integer  "application_id"
    t.integer  "country_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranking_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", :force => true do |t|
    t.integer  "category_id"
    t.integer  "country_id"
    t.integer  "ranking_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rankings", ["category_id", "country_id", "ranking_type_id"], :name => "idx_ranking", :unique => true

  create_table "ranks", :force => true do |t|
    t.integer  "application_id"
    t.integer  "ranking_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "application_id"
    t.integer  "stat"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_summaries", :force => true do |t|
    t.integer  "application_id"
    t.integer  "star5"
    t.integer  "star4"
    t.integer  "star3"
    t.integer  "star2"
    t.integer  "star1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "application_id"
    t.integer  "language_id"
    t.string   "signature"
    t.string   "author"
    t.string   "title"
    t.text     "content"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["application_id", "signature"], :name => "index_reviews_on_application_id_and_signature", :unique => true
  add_index "reviews", ["application_id"], :name => "index_reviews_on_application_id"

  create_table "screenshots", :force => true do |t|
    t.integer  "application_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", :force => true do |t|
    t.integer  "application_id"
    t.integer  "language_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.integer  "application_id"
    t.string   "value"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "whatsnews", :force => true do |t|
    t.integer  "application_id"
    t.integer  "language_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
