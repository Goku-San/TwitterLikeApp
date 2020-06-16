class MicropostsController < ApplicationController
  include CurrentUserFeed

  before_action :require_login

  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      redirect_to root_url, flash: { success: "Micropost created!" }
    else
      feed_items
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by id: params[:id]
    @micropost.destroy! unless @micropost.nil?

    flash[:success] = "Micropost deleted"
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content
  end
end
