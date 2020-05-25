class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build

    @feed, @feed_items = pagy current_user.feed, items: 10, size: [1, 1, 1, 1]
  end

  def help; end

  def about; end

  def contact; end
end
