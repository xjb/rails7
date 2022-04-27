class SessionsController < ApplicationController
  skip_before_action :assert_signed_in

  def new; end

  def create
    # if (user = User.find_or_create_by_auth_hash(auth_hash))
    if (user = auth_hash)
      sign_in(user)
      redirect_to root_path
    else
      redirect_to sign_in_path
    end
  end

  def destroy
    sign_out
    redirect_to sign_in_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"].tap do |v|
      require "pp"
      logger.debug(v.pretty_inspect)
    end
  end
end
