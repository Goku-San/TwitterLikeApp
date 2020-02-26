require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    get login_path

    assert_template 'sessions/new'

    assert_select 'form[action="/login"]'

    @user = users :goku
  end

  test "invalid login information" do
    post login_path, params: {
      session: {
        email:    "user@invalid",
        password: "foo"
      }
    }

    assert_template 'sessions/new'

    assert_select 'div#notifications'
    assert_select 'div.alert-danger'

    get root_path

    assert flash.empty?
  end

  test "valid login information" do
    post login_path, params: {
      session: {
        email:    @user.email,
        password: "password"
      }
    }

    assert_redirected_to @user

    follow_redirect!

    assert_template 'users/show'

    assert_select 'div#notifications'
    assert_select 'div.alert-success'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "log out functionality" do
    post login_path, params: {
      session: {
        email:    @user.email,
        password: "password"
      }
    }

    follow_redirect!

    assert_template 'users/show'

    assert user_is_logged_in?

    delete logout_path

    assert_not user_is_logged_in?

    assert_redirected_to root_url

    follow_redirect!

    assert_template 'static_pages/home'

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0

    # Simulate a user clicking logout in a second window.
    delete logout_path

    follow_redirect!

    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as @user, remember_me: '1'

    assert_not_empty cookies[:remember_token]

    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as @user, remember_me: '0'

    assert_nil cookies[:remember_token]
  end
end
