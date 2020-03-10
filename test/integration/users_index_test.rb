require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # To test pagination with Pagy
  include Pagy::Backend

  def setup
    @goku    = users :goku
    @vanessa = users :vanessa
  end

  test "index action including pagination and delete links as admin" do
    log_in_as @goku

    get users_path

    assert_template 'users/index'

    assert_select 'nav.pagination'

    # Page argument MUST be set!!
    # Items argument is optional, if you declare it in code, then you must delcare it here as well.
    @pagy, @users = pagy User.all, items: 10, page: 1

    # Checking if @pagy object sets its vars correctly, not important.
    assert_equal 10, @pagy.items
    assert_equal 1,  @pagy.page

    # This test is not important and it tests that only 10 links are displayed on page 1
    # Its based on the page argumnet(page: 1) from the above declaration!
    assert_select 'ul.users' do
      assert_select 'li.list-group-item', @pagy.items
    end

    # Tests that there is at least 1 link displayed on the page!
    @users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'delete'
    end
  end

  test "account_owner sholud have delete link on index action" do
    log_in_as @vanessa

    # using custom route to get to page 2 where user is, so the test passes
    # items size must be 10 users per page or the test fails!!
    get pagy_path(2)

    assert_template 'users/index'

    assert_select 'a', text: 'delete', count: 1
  end
end
