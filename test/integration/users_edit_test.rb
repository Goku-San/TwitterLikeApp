require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :goku

    get edit_user_path(@user)

    assert_template 'users/edit'

    assert_select "form[action='/users/#{@user.id}']"
    # assert_select "form[action=\"/users/#{@user.id}\"]"
  end

  test "unsuccessful edit" do
    patch user_path(@user), params: {
      user: {
        name:                  "",
        email:                 "user@invalid",
        password:              "foo",
        password_confirmation: "bar"
      }
    }

    assert_template 'users/edit'

    assert_select 'div#notifications'
    assert_select 'div.alert-danger'
  end

  test "successful edit" do
    name  = "Valid User"
    email = "user@valid.com"

    patch user_path(@user), params: {
      user: {
        name:                  name,
        email:                 email,
        password:              "",
        password_confirmation: ""
      }
    }

    assert_redirected_to @user

    assert_not flash.empty?

    @user.reload

    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
