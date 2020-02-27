require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @goku = users :goku
  end

  test "unsuccessful edit" do
    log_in_as @goku

    user_edit_path

    patch user_path(@goku), params: {
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
    log_in_as @goku

    user_edit_path

    name  = "Valid User"
    email = "user@valid.com"

    patch user_path(@goku), params: {
      user: {
        name:                  name,
        email:                 email,
        password:              "",
        password_confirmation: ""
      }
    }

    assert_redirected_to @goku

    assert_not flash.empty?

    @goku.reload

    assert_equal name,  @goku.name
    assert_equal email, @goku.email
  end

  test "edit with friendly forwarding" do
    get edit_user_path(@goku)

    assert_equal edit_user_url(@goku), session[:forwarding_url]

    log_in_as @goku

    assert_redirected_to edit_user_url(@goku)

    assert_nil session[:forwarding_url]
  end
end
