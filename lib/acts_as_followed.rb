# class User
#   #  acts_as_follower
#   has_many :followships, :as=>:follower 
# end
# 
# class Comment
#   #  acts_as_followed
#   has_many :followships, :as=>:followed 
# end
# 
# class Minion
#   #  acts_as_follower
#   has_many :followships, :as=>:follower 
# end
# 
# class Lord
#   #  acts_as_followed
#   has_many :followships, :as=>:followed
# end
# 
# class Followship
#   belongs_to :followed, :polymorphic => true
#   belongs_to :follower, :polymorphic => true
# end



# ActsAsFollowed
module SG
  module Acts #:nodoc
    module Followed #:nodoc
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_followed
          has_many :followships, :as => :followed, :dependent => :destroy, :class_name => "::Followship"
          include SG::Acts::Followed::InstanceMethods
        end
      end
             
      module InstanceMethods
        def add_followship(followship)
          followships << followship
        end
      end
    end
  end
end

# ActsAsFollower
module SG
  module Acts #:nodoc
    module Follower #:nodoc
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_follower
          has_many :followships, :as => :follower, :dependent => :destroy, :class_name => "::Followship" do
            def for(resource)
              find(:all, :conditions => {:followed_type => resource.class.to_s, :followed_id => resource.id}) 
            end
          end
          include SG::Acts::Follower::InstanceMethods
        end
      end
      
      module InstanceMethods
        def following?(resource)
          !followships.for(resource).empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, SG::Acts::Followed)
ActiveRecord::Base.send(:include, SG::Acts::Follower)