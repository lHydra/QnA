class Question < ApplicationRecord
  belongs_to :user
  has_many :answers
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, presence: true
  validates :body, presence: true

  accepts_nested_attributes_for :attachments
end
