require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @goku = users :goku
  end

  test "layout links when user logged out" do
    get root_path

    assert_template "static_pages/home"

    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path, count: 2
    assert_select "a[href=?]", login_path
  end

  test "layout links when user logged in" do
    log_in_as @goku

    follow_redirect!

    assert_template "users/show"

    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", user_path(@goku)
    assert_select "a[href=?]", edit_user_path(@goku)
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", logout_path
  end

  test "page should have proper title" do
    get contact_path

    assert_select "title", full_title("Contact")
  end
end
