require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new name:                  "Test User",
                     email:                 "user@test.com",
                     password:              "password",
                     password_confirmation: "password"
  end

  test "user object should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "

    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "

    assert_not @user.valid?
  end

  test "name should be at least two characters" do
    @user.name = "a"

    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51

    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 101 + "@example.com"

    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      irst.last@foo.jp
      alice+bob@baz.cn
    ]

    valid_addresses.each do |valid_address|
      @user.email = valid_address

      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
      user@example..com
    ]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address

      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase

    @user.save

    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"

    @user.email = mixed_case_email
    @user.save

    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6

    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5

    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated? :remember, ''
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create! content: "Lorem ipsum"

    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    goku = users :goku
    lana = users :lana

    assert_not goku.following? lana

    goku.follow lana
    assert goku.following? lana
    assert lana.followers.include? goku

    goku.unfollow lana
    assert_not goku.following? lana
  end

  test "feed should have the right posts" do
    goku   = users :goku
    malory = users :malory
    lana   = users :lana

    # Posts from followed user
    malory.microposts.each do |post_following|
      assert lana.feed.include? post_following
    end

    # Posts from self
    goku.microposts.each do |post_self|
      assert goku.feed.include? post_self
    end

    # Posts from unfollowed user
    malory.microposts.each do |post_unfollowed|
      assert_not goku.feed.include? post_unfollowed
    end
  end
end
