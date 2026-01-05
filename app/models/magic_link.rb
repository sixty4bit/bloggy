class MagicLink < ApplicationRecord
  EXPIRY = 15.minutes
  CODE_LENGTH = 6
  CODE_ALPHABET = "0123456789ABCDEFGHJKMNPQRSTVWXYZ".freeze

  belongs_to :identity

  enum :purpose, { sign_in: "sign_in", sign_up: "sign_up" }

  before_validation :generate_code, :set_expiry, on: :create

  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :stale, -> { where("expires_at <= ?", Time.current) }

  validates :code, presence: true, uniqueness: true

  class << self
    def consume(code)
      sanitized = sanitize_code(code)
      return nil if sanitized.blank?

      active.find_by(code: sanitized)&.consume
    end

    def sanitize_code(code)
      return nil if code.blank?

      code.to_s
          .upcase
          .tr("OIL", "011")
          .gsub(/[^#{CODE_ALPHABET}]/, "")
    end

    def cleanup
      stale.delete_all
    end
  end

  def consume
    destroy!
    self
  end

  def expired?
    expires_at <= Time.current
  end

  private

  def generate_code
    loop do
      self.code = CODE_LENGTH.times.map { CODE_ALPHABET[SecureRandom.random_number(CODE_ALPHABET.length)] }.join
      break unless MagicLink.exists?(code: code)
    end
  end

  def set_expiry
    self.expires_at = EXPIRY.from_now
  end
end
