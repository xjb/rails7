module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :assert_signed_in
    helper_method :signed_in?, :google?
  end

  protected

  def current_user
    # @current_user ||= User.find_by_uid(session[:uid])
    @current_user ||= session[:uid]
  end

  def sign_in(user)
    # session[:uid] = user.id
    session[:uid] = user.uid
  end

  def sign_out
    session.delete(:uid)
    @current_user = nil
  end

  def signed_in?
    current_user.present?
  end

  def assert_signed_in
    return if signed_in?

    redirect_to sign_in_path
  end

  def google?
    # "provider"=>"google_oauth2"
    session[:uid].present?
  end
end
