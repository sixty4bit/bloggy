class Sessions::MagicLinksController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to session_magic_link_path, alert: "Too many attempts. Try again later."
  }

  layout "public"

  def show
  end

  def create
    if (magic_link = MagicLink.consume(params[:code]))
      start_new_session_for(magic_link.identity)
      redirect_to after_authentication_url
    else
      redirect_to session_magic_link_path, alert: "Invalid or expired code."
    end
  end
end
