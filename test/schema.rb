ActiveRecord::Schema.define(:version => 2) do

  create_table "followships", :force => true do |t|     
    t.integer  "followed_id"
    t.string   "followed_type"
    t.integer  "follower_id"  
    t.string  "follower_type"  
    t.timestamps
  end

  create_table "followers", :force => true do |t|
    t.string   "login"
  end
  
  create_table "celebrities", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string "login"
  end
  
  create_table "comments", :force => true do |t|
    t.string "content"
  end
end