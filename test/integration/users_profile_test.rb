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

    assert_select 'nav.pagination'

    @post, @microposts = pagy @user.microposts, items: 10, page: 1

    @microposts.each do |post|
      assert_match post.content, response.body
    end
  end
end
