class Followship < ActiveRecord::Base
  set_table_name 'followships'
  
  belongs_to :followed, :polymorphic => true
  belongs_to :follower, :polymorphic => true
  
  validates_presence_of :follower, :followed
end