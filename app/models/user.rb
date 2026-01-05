class User < ApplicationRecord
  include User::Role

  belongs_to :account
  belongs_to :identity, optional: true

  validates :name, presence: true
  validates :identity_id, uniqueness: { scope: :account_id }, allow_nil: true

  scope :active, -> { where(active: true) }

  def deactivate!
    update!(active: false, identity: nil)
  end
end
