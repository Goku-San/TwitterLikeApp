require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "TwitterLikeApp"
  end

  test "should get home" do
    get root_url

    assert_response :success

    assert_select "title", @base_title
  end

  test "should get help" do
    assert_recognizes({ controller: "static_pages", action: "help" }, "help")

    get help_url

    assert_response :success

    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    assert_recognizes({ controller: "static_pages", action: "about" }, "about")

    get about_url

    assert_response :success

    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    assert_recognizes({ controller: "static_pages", action: "contact" }, "contact")

    get contact_url

    assert_response :success

    assert_select "title", "Contact | #{@base_title}"
  end
end
