require File.join(File.dirname(__FILE__), 'test_helper')

class Celebrity < ActiveRecord::Base
  acts_as_followed
end

class Follower < ActiveRecord::Base
  acts_as_follower
end

class User < ActiveRecord::Base
  acts_as_follower
end

class Comment < ActiveRecord::Base
  acts_as_followed
end

class ActsAsFollowedTest < Test::Unit::TestCase
  fixtures :followers, :celebrities, :users, :comments, :followships
  
  def setup
    @aslan = celebrities(:aslan)
    @zak = followers(:zak)
    @flash = followers(:flash)
    @flora = users(:flora)
    @comment = comments(:comment_one)
    @flash_followship = followships(:first)
    @flora_followship = followships(:second)
  end
  
  def test_should_indicate_user_is_following_the_resource
    assert_equal @flash.following?(@aslan), true
  end

  def test_should_indicate_user_is_not_following_the_resource
    assert_equal @zak.following?(@aslan), false
  end
  
  def test_followships_include_users
    assert_equal @aslan.followships.first, @flash_followship
  end
  
  def test_followships_only_have_followees
    assert_equal @aslan.followships.size, 2
  end
  
  def test_user_followships_proxy_method_empty_with_no_followships
    assert_equal @zak.followships.for(@aslan).size, 0
  end
  
  def test_user_followships_reflects_followships
    assert_equal @flash.followships.for(@aslan).size, 1
  end
  
  def test_that_polymorphic_followships_work
    assert_equal @flora.following?(@comment), true
  end
  
  def test_that_a_follower_can_follow_different_types_of_things_to_follow
    assert_equal @flora.following?(@aslan), true
  end
  
end

