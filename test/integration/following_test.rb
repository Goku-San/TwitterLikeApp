require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  include Pagy::Backend

  def setup
    @goku = users :goku
    @lana = users :lana

    log_in_as @goku
  end

  test "following page" do
    get following_user_path(@goku)

    assert_not @goku.following.empty?

    assert_match @goku.following.count.to_s, response.body

    @goku.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@goku)

    assert_not @goku.followers.empty?

    assert_match @goku.followers.count.to_s, response.body

    @goku.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow a user the standard way" do
    assert_difference '@goku.following.count', 1 do
      post relationships_path, params: { followed_id: @lana.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@goku.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @lana.id }
    end
  end

  test "should unfollow a user the standard way" do
    @goku.follow @lana

    relationship = @goku.active_relationships.find_by followed_id: @lana.id

    assert_difference '@goku.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @goku.follow @lana

    relationship = @goku.active_relationships.find_by followed_id: @lana.id

    assert_difference '@goku.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test "feed on Home page" do
    get root_path

    @feed, @feed_items = pagy @goku.feed, items: 10, page: 1

    @feed_items.each do |post|
      assert_match CGI.escapeHTML(post.content), response.body
    end
  end
end
