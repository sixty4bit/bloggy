class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user

  delegate :identity, to: :session, allow_nil: true

  def account
    user&.account
  end
end
