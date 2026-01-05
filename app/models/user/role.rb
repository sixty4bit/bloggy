module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, { owner: "owner", admin: "admin", member: "member" }
  end

  def admin_access?
    owner? || admin?
  end

  def can_manage?(other_user)
    return false unless admin_access?
    return false if other_user.owner?
    other_user.account_id == account_id
  end
end
