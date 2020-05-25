require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include Pagy::Backend

  def setup
    @user = users :goku

    log_in_as @user
  end

  test "profile display" do
    get user_path @user

    assert_template 'users/show'

    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img'

    assert_match @user.microposts.count.to_s, response.body

    assert_select 'section.stats'

    assert_select 'a[href=?]', following_user_path(@user) do
      assert_select 'strong#following', html: @user.following.count.to_s
      assert_select 'a', text: /following/
    end

    assert_select 'a[href=?]', followers_user_path(@user) do
      assert_select 'strong#followers', html: @user.followers.count.to_s
      assert_select 'a', text: /followers/
    end

    assert_select 'nav.pagination'

    @post, @microposts = pagy @user.microposts, items: 10, page: 1

    @microposts.each do |post|
      assert_match post.content, response.body
    end
  end
end
