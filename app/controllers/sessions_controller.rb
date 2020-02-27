class SessionsController < ApplicationController
  before_action :set_user, only: :create

  def new; end

  def create
    # if @user && @user.authenticate(params[:session][:password])
    if @user&.authenticate(params[:session][:password])
      log_in @user

      remember_user_or_not

      redirect_back_or @user, flash: { success: "Welome back #{@user.name}" }
    else
      flash.now[:danger] = "Invalid email or password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?

    redirect_to root_url
  end

  private

  def set_user
    @user = User.find_by email: params[:session][:email].downcase
  end

  def remember_user_or_not
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  end
end
