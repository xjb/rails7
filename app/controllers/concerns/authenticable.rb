module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :assert_signed_in
    helper_method :signed_in?
    helper_method :google?
    helper_method :github?
    helper_method :microsoft?
    helper_method :gitlab?
    helper_method :keycloak?
  end

  protected

  def current_user
    # @current_user ||= User.find_by_uid(session[:uid])
    @current_user ||= session[:uid]
  end

  def sign_in(user)
    # session[:uid] = user.id
    session[:uid] = user.uid
    session[:provider] = user.provider
  end

  def sign_out
    session.delete(:uid)
    session.delete(:provider)
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
    session[:provider] == "google_oauth2"
  end

  def github?
    session[:provider] == "github"
  end

  def microsoft?
    session[:provider].to_s.start_with? "microsoft"
  end

  def gitlab?
    session[:provider] == "gitlab"
  end

  def keycloak?
    session[:provider] == "keycloak"
  end
end
