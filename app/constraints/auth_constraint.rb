# Not needed, this is just for future reference.
# class AuthConstraint
#   def self.matches? request
#     user = current_user request
#     user.present?
#   end

#   def self.current_user request
#     return unless request.session[:user_id]

#     @current_user ||= User.find_by id: request.session[:user_id]
#   end
# end
