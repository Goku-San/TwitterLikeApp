module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember user
    user.remember

    cookies.signed[:user_id] = { value: user.id, expires: 5.minutes.from_now }
    # cookies.permanent.signed[:user_id] = user.id

    cookies[:remember_token] = { value: user.remember_token, expires: 5.minutes.from_now }
    # cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id

      return unless user&.authenticated?(cookies[:remember_token])

      log_in user

      @current_user = user
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget user
    user.forget

    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user

    session.delete :user_id

    @current_user = nil
  end
end