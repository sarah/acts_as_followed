class Followship < ActiveRecord::Base
  set_table_name 'followships'
  
  belongs_to :followed, :polymorphic => true
  belongs_to :user 
  
  validates_presence_of :user, :followed
end