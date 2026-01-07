class Article < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  scope :published, -> { where(published: true) }
  scope :drafts, -> { where(published: false) }
  scope :recent, -> { order(created_at: :desc) }

  def publish!
    update!(published: true, published_at: Time.current)
  end

  def unpublish!
    update!(published: false, published_at: nil)
  end
end
