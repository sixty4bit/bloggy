class SignupsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_signup_path, alert: "Too many attempts. Try again later."
  }

  layout "public"

  def new
  end

  def create
    identity = Identity.find_or_create_by!(email_address: params[:email_address])
    magic_link = identity.send_magic_link(purpose: :sign_up)
    serve_magic_link_code(magic_link)

    redirect_to session_magic_link_path
  end
end
