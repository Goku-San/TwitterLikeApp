require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    get signup_path

    assert_template 'users/new'

    assert_select 'form#new_user'
    assert_select 'form[action="/signup"]'
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

    follow_redirect!

    assert_template 'users/show'

    assert_select 'div#notifications'
    assert_select 'div.alert-success'

    assert logged_in?
  end
end
