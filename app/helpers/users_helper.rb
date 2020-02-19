module UsersHelper
  def gravatar_for user, size: 200
    gravatar_id = Digest::MD5.hexdigest user.email.downcase

    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"

    gravatar_url
  end
end
