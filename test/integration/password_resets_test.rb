require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear

    @user = users :goku

    get new_password_reset_path

    assert_template 'password_resets/new'
  end

  test "should render new when email field empty" do
    post password_resets_path, params: { password_reset: { email: "" } }

    assert_not flash.empty?

    assert_template 'password_resets/new'
  end

  test "should redirect to root_url when email is sent with valid email address" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    assert_not_equal @user.reset_password_digest, @user.reload.reset_password_digest

    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_not flash.empty?

    assert_redirected_to root_url
  end

  test "sholud redirect to root_url if user has invalid email or is inactive or wrong token" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    # Password reset form
    user = assigns :user

    # Wrong email
    get edit_password_reset_path(user.reset_password_token, email: "")

    assert_redirected_to root_url

    # Inactive user
    user.toggle! :activated

    get edit_password_reset_path(user.reset_password_token, email: user.email)

    assert_redirected_to root_url

    user.toggle! :activated

    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)

    assert_redirected_to root_url
  end

  test "sholud show actual password reset form when given right email and token" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = assigns :user

    # Right email, right token
    get edit_password_reset_path(user.reset_password_token, email: user.email)

    assert_template 'password_resets/edit'

    assert_select "input[name=email][type=hidden][value=?]", user.email
  end

  test "invalid password and confirmation" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = assigns :user

    patch password_reset_path(user.reset_password_token), params: {
      email: user.email,
      user:  {
        password:              "foobaz",
        password_confirmation: "barquux"
      }
    }

    assert_select 'div#error-notification'

    assert_template 'password_resets/edit'
  end

  test "empty password" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = assigns :user

    patch password_reset_path(user.reset_password_token), params: {
      email: user.email,
      user:  {
        password:              "",
        password_confirmation: ""
      }
    }

    assert_select 'div#error-notification'

    assert_template 'password_resets/edit'
  end

  test "valid password and confirmation" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = assigns :user

    patch password_reset_path(user.reset_password_token), params: {
      email: user.email,
      user:  {
        password:              "foobaz",
        password_confirmation: "foobaz"
      }
    }

    assert user_is_logged_in?

    assert_not flash.empty?

    assert_redirected_to user

    # clear the reset password digest on successful password update
    assert_nil user.reload.reset_password_digest
  end

  test "expired token" do
    post password_resets_path, params: { password_reset: { email: @user.email } }

    user = assigns :user

    user.update_attribute :reset_sent_at, 3.hours.ago

    patch password_reset_path(user.reset_password_token), params: {
      email: user.email,
      user:  {
        password:              "foobar",
        password_confirmation: "foobar"
      }
    }

    assert_response :redirect

    follow_redirect!

    assert_match /expired/i, response.body
  end
end
