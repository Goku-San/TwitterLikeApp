class UsersController < ApplicationController
  before_action :logged_in_user,  only:   %i[index edit update]
  before_action :find_user_by_id, except: %i[index new create]
  before_action :correct_user,    only:   %i[edit update]

  def index
    @users = User.all
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

  def destroy; end

  private

  def logged_in_user
    return if logged_in?

    store_location

    redirect_to login_path, flash: { danger: "Please log in" }
  end

  def find_user_by_id
    @user = User.find params[:id]
  end

  def correct_user
    return if current_user.id == @user.id

    redirect_to root_path, flash: { danger: "Not authorized!" }
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
