class UsersController < ApplicationController
  before_action :find_user_by_id, except: %i[new create]

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

  private

  def find_user_by_id
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
