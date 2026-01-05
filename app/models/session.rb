class Session < ApplicationRecord
  belongs_to :identity

  generates_token_for :session
end
