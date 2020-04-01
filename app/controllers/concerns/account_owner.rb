module AccountOwner
  extend ActiveSupport::Concern

  included do
    helper_method :owner?
  end

  def owner? user
    current_user.id == user.id
  end
end
