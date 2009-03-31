require File.join(File.dirname(__FILE__), 'test_helper')

class Celebrity < ActiveRecord::Base
  acts_as_followed
end

class Follower < ActiveRecord::Base
  acts_as_follower
end

class ActsAsFollowedTest < Test::Unit::TestCase
  fixtures :followers, :celebrities, :followships
  
  def setup
    @aslan = celebrities(:aslan)
    @zak = users(:zak)
    @flash = users(:flash)
    @flash_followship = followships(:first)
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
    assert_equal @aslan.followships.size, 1
  end
  
  def test_user_followships_proxy_method_empty_with_no_followships
    assert_equal @zak.followships.for(@aslan).size, 0
  end
  
  def test_user_followships_reflects_followships
    assert_equal @flash.followships.for(@aslan).size, 1
  end
  
end

