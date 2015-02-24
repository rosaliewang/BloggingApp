class Article < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  scope :label, -> (label) { where label: label }
  friendly_id :title, use: :slugged

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 70 }, allow_blank: false
  validates :content, presence: true
end
