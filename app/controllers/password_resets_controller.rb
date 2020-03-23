class PasswordResetsController < ApplicationController
  before_action :set_user,         only: %i[edit update]
  before_action :valid_user,       only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_password_reset_digest
      @user.send_password_reset_email

      redirect_to root_url, flash: { warning: "Email sent with password reset instructions" }
    else
      flash.now[:danger] = "Email address not found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, "can't be blank"

      render :edit
    elsif @user.update user_params
      log_in @user

      @user.update_attribute :reset_password_digest, nil

      redirect_to @user, flash: { success: "Password has been reset successfully." }
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by email: params[:email].downcase
  end

  # Confirms a valid user.
  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset_password, params[:id])

    redirect_to root_url, flash: { warning: "The user is non-existent or account not active!" }
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.reset_password_expired?

    redirect_to new_password_reset_url, flash: { danger: "Password reset has expired." }
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
