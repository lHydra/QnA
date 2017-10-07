class Question < ApplicationRecord
  belongs_to :user
  has_many :answers
  has_many :attachments

  validates :title, presence: true
  validates :body, presence: true
end
