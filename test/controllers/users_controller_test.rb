require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    assert_recognizes({ controller: "users", action: "new" }, "signup")

    get signup_url

    assert_response :success

    assert_select "title", "Signup | #{base_title}"
  end
end
