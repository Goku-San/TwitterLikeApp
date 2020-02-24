require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    assert_recognizes({ controller: "sessions", action: "new" }, "login")

    get login_url

    assert_response :success

    assert_select "title", "Log in | #{base_title}"
  end
end
