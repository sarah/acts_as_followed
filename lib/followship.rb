class Followship < ActiveRecord::Base
  set_table_name 'followships'
  
  belongs_to :followed, :polymorphic => true
  belongs_to :follower, :class_name => "User" 
  
  validates_presence_of :follower, :followed
end