class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    omniauth_provider('FACEBOOK')
  end

  def vkontakte
    omniauth_provider('VKONTAKTE')
  end

  def twitter
    omniauth_provider('TWITTER')
  end

  private

  def omniauth_provider(provider_name)
    # render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      # реализовать!!! если не persisted
    end
  end
end
