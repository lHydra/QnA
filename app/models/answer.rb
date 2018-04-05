class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :attachments

  validates :body, presence: true
end
