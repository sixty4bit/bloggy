class Account < ApplicationRecord
  has_many :users, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates :name, presence: true

  def self.create_with_owner(name:, owner_identity:, owner_name:)
    transaction do
      create!(name: name).tap do |account|
        account.users.create!(
          identity: owner_identity,
          name: owner_name,
          role: :owner
        )
        account.create_subscription!(
          trial_ends_at: 14.days.from_now
        )
      end
    end
  end

  def owner
    users.find_by(role: :owner)
  end
end
