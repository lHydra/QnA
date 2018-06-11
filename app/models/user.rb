class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook vkontakte]
  has_many :questions
  has_many :answers
  has_many :authorizations
  has_many :subscriptions
  has_many :subscribed_questions, through: :subscriptions, source: :question

  def subscribe!(question)
    subscriptions.create!(question_id: question.id)
  end

  def unsubscribe!(question)
    subscriptions.find_by(question_id: question.id).destroy!
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email].downcase
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0,15]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def self.weekly_mailing
    find_each do |user|
      WeeklyMailer.delay.weekly_digest(user)
    end
  end
end
