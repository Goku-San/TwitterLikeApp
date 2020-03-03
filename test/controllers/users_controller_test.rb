require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @goku    = users :goku
    @vanessa = users :vanessa
  end

  test "should redirect index when not logged in" do
    get users_path

    assert_redirected_to login_url
  end

  test "should get index when logged in" do
    log_in_as @goku

    get users_url

    assert_response :success

    assert_recognizes({ controller: "users", action: "index" }, "users")

    assert_select "title", "Users | #{base_title}"
  end

  test "should get new" do
    get signup_url

    assert_response :success

    assert_recognizes({ controller: "users", action: "new" }, "signup")

    assert_select "title", "Signup | #{base_title}"
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@goku)

    assert_not flash.empty?

    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@goku), params: {
      user: {
        name:  @goku.name,
        email: @goku.email
      }
    }

    assert_not flash.empty?

    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @vanessa

    get edit_user_path(@goku)

    assert_not flash.empty?

    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @vanessa

    patch user_path(@goku), params: {
      user: {
        name:  @goku.name,
        email: @goku.email
      }
    }

    assert_not flash.empty?

    assert_redirected_to root_url
  end
end
