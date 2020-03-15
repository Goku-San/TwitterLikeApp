require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    get signup_path

    assert_template 'users/new'

    assert_select 'form#new_user'
    assert_select 'form[action="/signup"]'

    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          name:                  "",
          email:                 "user@invalid",
          password:              "foo",
          password_confirmation: "bar"
        }
      }
    end

    assert_select 'div#error-notification'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    assert_difference 'User.count' do
      post signup_path, params: {
        user: {
          name:                  "test user",
          email:                 "user@valid.com",
          password:              "password",
          password_confirmation: "password"
        }
      }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns :user

    assert_not user.activated?

    # Try to go to show page
    get user_path(user)

    assert_redirected_to root_url

    # Try to log in before activation.
    log_in_as user

    assert_not user_is_logged_in?

    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)

    assert_not user_is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')

    assert_not user_is_logged_in?

    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)

    assert user.reload.activated?

    follow_redirect!

    assert_template 'users/show'

    assert_select 'div#notifications'
    assert_select 'div.alert-success'

    assert logged_in?
  end
end
