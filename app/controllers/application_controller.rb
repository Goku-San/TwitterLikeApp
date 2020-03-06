class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Pagy::Backend # For pagination
  include SessionsHelper
end
