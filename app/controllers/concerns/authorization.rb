module Authorization
  extend ActiveSupport::Concern

  private

  def require_account
    unless Current.account
      redirect_to new_signup_completion_path, alert: "Please complete your account setup."
    end
  end

  def require_active_subscription
    unless Current.account&.subscription&.active_or_trialing?
      redirect_to account_subscription_path, alert: "Please update your subscription."
    end
  end

  def require_admin
    unless Current.user&.admin_access?
      redirect_to root_path, alert: "You don't have permission to do that."
    end
  end
end
