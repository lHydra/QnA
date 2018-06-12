class SubscriberMailer < ApplicationMailer
  def subscriber_info(user, question)
    @user = user
    @question = question

    mail(to: @user.email, subject: 'There is a new answer')
  end
end
