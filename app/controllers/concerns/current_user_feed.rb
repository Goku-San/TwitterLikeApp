module CurrentUserFeed
  def feed_items
    @feed, @feed_items = pagy current_user.feed, items: 10, size: [1, 1, 1, 1]
    render template: 'users/logged_in_user_home_page'
  end

  # Returns a user's status feed
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"

    Micropost.where "user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id
  end
end
