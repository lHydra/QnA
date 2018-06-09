class WeeklyMailer < ApplicationMailer
  default from: 'digest@example.com'

  def weekly_digest(user)
    @user = user
    time_interval = (Time.now.midnight - 7.days)..Time.now.midnight
    @questions = Question.where(created_at: time_interval)

    mail(to: @user.email, subject: 'Weekly digest from QnA')
  end
end
