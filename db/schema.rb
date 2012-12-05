# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121205062418) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "token"
    t.string   "secret"
    t.string   "username"
    t.string   "profile_image_url"
  end

  create_table "retweets", :force => true do |t|
    t.string   "twitter_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "tweeted_at"
    t.integer  "tweet_id"
  end

  create_table "searches", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "from_date"
    t.datetime "to_date"
    t.integer  "count"
  end

  create_table "searches_terms", :id => false, :force => true do |t|
    t.integer "search_id"
    t.integer "term_id"
  end

  create_table "sentiments", :force => true do |t|
    t.integer  "tweet_id"
    t.string   "label"
    t.float    "negative"
    t.float    "positive"
    t.float    "neutral"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "terms", :force => true do |t|
    t.string   "type"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "tweets", :force => true do |t|
    t.string   "status_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "text"
    t.integer  "reply_count"
    t.datetime "tweeted_at"
    t.integer  "search_id"
    t.integer  "twitter_user_id"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "user_id"
    t.string   "handle"
    t.integer  "follower_count"
    t.integer  "friend_count"
    t.string   "location"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "search_id"
    t.integer  "influence"
    t.integer  "outreach"
    t.string   "avatar"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
