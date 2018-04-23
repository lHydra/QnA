class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_user

  def facebook
    login('Facebook')
  end

  def vkontakte
    login('Vkontakte')
  end

  private

  def find_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def login(provider)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
