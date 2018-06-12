class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable

  accepts_nested_attributes_for :attachments

  validates :body, presence: true

  after_create :send_email_to_subscribers

  private

  def send_email_to_subscribers
    question.subscribers.each do |user|
      if user.subscribing?(question)
        SubscriberMailer.delay.subscriber_info(user, question)
      end
    end
  end
end
