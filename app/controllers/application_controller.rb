class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_cookies

  protected

  def set_cookies
    cookies.signed[:user_id] = current_user.id if current_user
  end
end
