class Subscription < ApplicationRecord
  belongs_to :account

  enum :status, {
    trialing: "trialing",
    active: "active",
    past_due: "past_due",
    canceled: "canceled"
  }

  enum :plan, {
    individual: "individual",
    team: "team",
    enterprise: "enterprise"
  }

  validates :seat_limit, numericality: { greater_than: 0 }
  validates :seats_used, numericality: { greater_than_or_equal_to: 0 }

  def seats_available?
    seats_used < seat_limit
  end

  def seats_remaining
    seat_limit - seats_used
  end

  def active_or_trialing?
    active? || trialing?
  end

  def trial_active?
    trialing? && trial_ends_at&.future?
  end
end
