module SessionManagement
  extend ActiveSupport::Concern

  included do
    helper_method :logged_in?, :current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id

      return unless user&.authenticated?(:remember, cookies[:remember_token])

      log_in user

      @current_user = user
    end
  end

  def log_in user
    session[:user_id] = user.id
  end

  def log_out
    forget current_user

    session.delete :user_id

    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember user
    user.remember

    cookies.signed[:user_id] = { value: user.id, expires: 5.minutes.from_now }
    # cookies.permanent.signed[:user_id] = user.id

    cookies[:remember_token] = { value: user.remember_token, expires: 5.minutes.from_now }
    # cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session.
  def forget user
    user.forget

    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def require_login
    return if logged_in?

    store_location

    redirect_to login_path, flash: { danger: "Please log in" }
  end

  def require_logout
    return unless logged_in?

    redirect_to current_user, flash: { info: "Already logged in." }
  end

  # Redirects to stored location or default.
  def redirect_back_or default, options = {}
    redirect_to session[:forwarding_url] || default, options

    session.delete :forwarding_url
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
