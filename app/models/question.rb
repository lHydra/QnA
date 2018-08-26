class Question < ApplicationRecord
  belongs_to :user
  has_many :answers
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user
end
