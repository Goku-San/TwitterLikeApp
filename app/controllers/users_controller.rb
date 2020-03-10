class UsersController < ApplicationController
  before_action :logged_out_user, only:   %i[index edit update destroy]
  before_action :find_user_by_id, except: %i[index new create]
  before_action :correct_user,    only:   %i[edit update]
  before_action :admin_or_correct_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, items: 10, size: [1, 1, 1, 1]
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      redirect_to @user, flash: { success: "Welcome #{@user.name}" }
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      redirect_to @user, flash: { success: "Profile updated successfully" }
    else
      render :edit
    end
  end

  def destroy
    if current_user.admin?
      @user.destroy!

      redirect_to users_url, flash: { success: "User deleted" }
    elsif account_owner?
      log_out

      @user.destroy!

      redirect_to root_url, flash: { info: "Sorry to see you go..." }
    end
  end

  private

  # TODO: Fix sign up route when user is logged in
  # def logged_in_user
  #   return unless logged_in?

  #   redirect_back fallback_location: '/', allow_other_host: false
  # end

  def logged_out_user
    return if logged_in?

    store_location

    redirect_to login_path, flash: { danger: "Please log in" }
  end

  def find_user_by_id
    @user = User.find params[:id]
  end

  def correct_user
    return if account_owner?

    redirect_to root_path, flash: { danger: "Not authorized!" }
  end

  def admin_or_correct_user
    return if current_user.admin? || account_owner?

    redirect_to users_path, flash: { danger: "Not authorized!" }
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def account_owner?
    owner? @user
  end
end
