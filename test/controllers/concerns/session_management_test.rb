require 'test_helper'

# This module creates helper_method,
# if not the test errors out with
# NoMethodError --> undefined method helper_method for SessionManagementControllerTest
module HelperMethod
  def helper_method *methods
    methods.flat_map do |method|
      self.class.send :define_method, method do |*args, &blk|
        __send__ method, *args, &blk
      end
    end
  end
end

module SessionManagementTest
  extend ActiveSupport::Concern

  included do
    def setup
      @user = users :goku

      remember @user
    end

    test "current_user returns right user when session is nil" do
      assert_equal @user, current_user

      assert user_is_logged_in?
    end

    test "current_user returns nil when remember digest is wrong" do
      @user.update_attribute :remember_digest, User.digest(User.new_token)

      assert_nil current_user
    end
  end
end

# Creating fake controller in order to test concerns!!
class SessionManagementControllerTest < ActionController::TestCase
  extend HelperMethod

  include SessionManagement
  include SessionManagementTest
end
