module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    Current.session.present?
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    if (token = cookies.signed[:session_token])
      if (session = Session.find_by_token_for(:session, token))
        set_current_session(session)
      end
    end
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url if request.get?
    redirect_to new_session_path
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || dashboard_path
  end

  def start_new_session_for(identity)
    identity.sessions.create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent&.first(500)
    ).tap { |s| set_current_session(s) }
  end

  def set_current_session(session)
    Current.session = session

    if (user = session.identity.users.active.first)
      Current.user = user
    end

    cookies.signed.permanent[:session_token] = {
      value: session.generate_token_for(:session),
      httponly: true,
      same_site: :lax
    }
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_token)
  end

  def serve_magic_link_code(magic_link)
    flash[:magic_link_code] = magic_link&.code
  end
end
