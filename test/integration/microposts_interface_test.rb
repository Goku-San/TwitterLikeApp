require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  include Pagy::Backend

  def setup
    @user = users :goku
  end

  test "micropost interface" do
    log_in_as @user

    get root_path

    assert_select 'nav.pagination'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end

    assert_select 'div#error-notification'

    # Valid submission
    content = "This micropost really ties the room together"

    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end

    assert_redirected_to root_url

    follow_redirect!

    assert_match content, response.body

    # Delete a post.
    assert_select 'a', text: 'delete'

    @post, @microposts = pagy @user.microposts, items: 10, page: 1

    first_post = @microposts.first

    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_post)
    end

    # # Visit a different user.
    get user_path(users(:vanessa))

    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count for user with posts" do
    log_in_as @user

    get root_path

    assert_match "#{@user.microposts.count} microposts", response.body
  end

  test "micropost sidebar count for user with no posts" do
    other_user = users :lana

    log_in_as other_user

    get root_path

    assert_match "0 microposts", response.body

    other_user.microposts.create! content: "A micropost"

    get root_path

    assert_match "1 micropost", response.body
  end
end
