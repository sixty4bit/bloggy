class Identity < ApplicationRecord
  has_many :magic_links, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :accounts, through: :users

  generates_token_for :transfer

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :email_address, presence: true,
                            uniqueness: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }

  def send_magic_link(purpose: :sign_in)
    magic_links.create!(purpose: purpose).tap do |link|
      MagicLinkMailer.code(link).deliver_later
    end
  end
end
