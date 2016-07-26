require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

class CallbacksController < ::Devise::OmniauthCallbacksController

  def wechat_qiye
    if request.env["omniauth.auth"].uid.nil?
      redirect_to refinery.new_authentication_devise_user_session_path
      return false
    end
    @user = Refinery::Authentication::Devise::User.from_omniauth(request.env["omniauth.auth"])
    sign_in(@user)
    redirect_to refinery.root_path
  end

  def failure
    logger.debug('###########################################')
    logger.debug(params)
    logger.debug(request.env.keys.sort)
    logger.debug(request.env["omniauth.error"])
    logger.debug(request.env["omniauth.error.type"])
    logger.debug('###########################################')
    redirect_to refinery.new_authentication_devise_user_session_path
  end
end
