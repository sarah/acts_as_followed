require File.join(File.dirname(__FILE__), 'test_helper')

# Some examples of usage
class Celebrity < ActiveRecord::Base
  acts_as_followed
end

class Follower < ActiveRecord::Base
  acts_as_follower
end

class User < ActiveRecord::Base
  acts_as_follower
  acts_as_followed
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
    @lucy = users(:lucy)
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
    assert_equal @aslan.followerships.first, @flash_followship
  end
  
  def test_followships_only_have_followees
    assert_equal @aslan.followerships.size, 2
  end
  
  def test_user_followships_proxy_method_empty_with_no_followships
    assert_equal @zak.followeeships.for(@aslan).size, 0
  end
  
  def test_user_followships_reflects_followships
    assert_equal @flash.followeeships.for(@aslan).size, 1
  end
  
  def test_that_polymorphic_followships_work
    assert_equal @flora.following?(@comment), true
  end
  
  def test_that_a_follower_can_follow_different_types_of_things_to_follow
    assert_equal @flora.following?(@aslan), true
  end
  
  def test_that_a_resource_can_be_a_follower_and_a_followee_ie_reciprocal_love
    assert_equal @flora.following?(@lucy), true
    assert_equal @lucy.following?(@flora), true
  end
  
  def test_a_followship_requires_a_follower
    follower = User.new
    followship = Followship.new(:follower => follower)
    assert !followship.valid?
    assert followship.errors.on(:followed)
  end

  def test_a_followship_requires_a_followed
    followed = User.new
    followship = Followship.new(:followed => followed)
    assert !followship.valid?
    assert followship.errors.on(:follower)
  end
  
  def test_a_followship_is_valid_with_a_followed_and_a_follower
    follower = User.new
    followed = User.new
    followship = Followship.new(:followed => followed, :follower => follower)
    assert followship.valid?
  end
  
  def test_acts_as_follower_can_start_following
    assert_equal @zak.following?(@aslan), false
    assert_equal @zak.followeeships.for(@aslan).size, 0
    @zak.start_following!(@aslan)
    assert_equal @zak.followeeships.for(@aslan).size, 1
    assert_equal @zak.following?(@aslan), true
  end

end

