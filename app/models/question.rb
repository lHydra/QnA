class Question < ApplicationRecord
  belongs_to :user
  has_many :answers
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable

  validates :title, presence: true
  validates :body, presence: true

  accepts_nested_attributes_for :attachments
end
