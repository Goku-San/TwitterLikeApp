module ApplicationHelper
  include Pagy::Frontend # For pagination

  # This method supports fancy-routes, e.g. get '/your_route/:page',
  # that'll produce paths like your_route/23 instead of your_route?page=23.
  # This overrides the original method of pagy gem.
  def pagy_url_for page, pagy
    params = request.query_parameters.merge only_path: true, pagy.vars[:page_param] => page
    url_for params
  end

  # Returns the full title on a per-page basis.
  def full_title page_title = ""
    base_title = "TwitterLikeApp"

    return base_title if page_title.empty?

    page_title + " | " + base_title
  end
end
