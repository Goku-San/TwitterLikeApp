require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # To test pagination with Pagy
  include Pagy::Backend

  def setup
    @goku = users :goku
  end

  test "index including pagination" do
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
    end
  end
end
