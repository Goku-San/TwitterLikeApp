ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper
  include SessionsHelper

  def base_title
    "TwitterLikeApp"
  end

  # Turns out that this method is unnecessary because I can include SessionsHelper
  def user_is_logged_in?
    !session[:user_id].nil?
  end

  def login_as user
    session[:user_id] = user.id
  end

  def user_edit_path
    get edit_user_path(@goku)

    assert_template 'users/edit'

    assert_select "form[action='/users/#{@goku.id}']"
    # assert_select "form[action=\"/users/#{@goku.id}\"]"
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  def log_in_as user, password: 'password', remember_me: '1'
    post login_path, params: {
      session: {
        email:       user.email,
        password:    password,
        remember_me: remember_me
      }
    }
  end
end
