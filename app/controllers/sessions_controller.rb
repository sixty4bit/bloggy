class SessionsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_session_path, alert: "Too many attempts. Try again later."
  }

  layout "public"

  def new
  end

  def create
    if (identity = Identity.find_by(email_address: params[:email_address]))
      magic_link = identity.send_magic_link
      serve_magic_link_code(magic_link)
    end

    redirect_to session_magic_link_path
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "You have been signed out."
  end
end
