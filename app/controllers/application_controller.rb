class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionManagement
  include AccountOwner
  include Pagy::Backend # For pagination
  include BrowserCache
end
