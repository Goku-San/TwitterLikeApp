class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase

    # if @user && @user.authenticate(params[:session][:password])
    if @user&.authenticate(params[:session][:password])
      log_in @user
      redirect_to @user, flash: { success: "Welome back #{@user.name}" }
    else
      flash.now[:danger] = "Invalid email or password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?

    redirect_to root_url
  end
end
