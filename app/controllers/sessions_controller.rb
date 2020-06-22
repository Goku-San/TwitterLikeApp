class SessionsController < ApplicationController
  before_action :require_logout, only: %i[new create]
  before_action :set_user,       only: :create

  def new; end

  def create
    # if @user && @user.authenticate(params[:session][:password])
    if @user&.authenticate(params[:session][:password])
      # This line is commented to disable user confirmation email
      # return activate_user! unless @user.activated?

      login_active_user
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

  def activate_user!
    flash[:warning] = "Account not activated. Check your email for the activation link."
    redirect_to root_url
  end

  def login_active_user
    log_in @user

    remember_user_or_not

    redirect_back_or @user, flash: { success: "Welome back #{@user.name}" }
  end

  def remember_user_or_not
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  end
end
