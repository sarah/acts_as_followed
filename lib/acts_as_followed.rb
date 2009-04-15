# ActsAsFollowed
module SG
  module Acts #:nodoc
    module Followed #:nodoc
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_followed
          has_many :followerships, :as => :followed, :dependent => :destroy, :class_name => "::Followship"
          include SG::Acts::Followed::InstanceMethods
        end
      end
             
      module InstanceMethods
        # none atm
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
          has_many :followeeships, :as => :follower, :dependent => :destroy, :class_name => "::Followship" do
            def for(resource)
              find(:all, :conditions => {:followed_type => resource.class.to_s, :followed_id => resource.id}) 
            end
          end
          include SG::Acts::Follower::InstanceMethods
        end
      end
      
      module InstanceMethods
        def start_following!(resource)
          followeeships.create(:followed => resource)
        end
        
        def following?(resource)
          !followeeships.for(resource).empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, SG::Acts::Followed)
ActiveRecord::Base.send(:include, SG::Acts::Follower)