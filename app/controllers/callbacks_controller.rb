require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

class CallbacksController < ::Devise::OmniauthCallbacksController

  def wechat_qiye
    logger.debug('############################################')
    logger.debug(request.env["omniauth.auth"])
    logger.debug('############################################')
    @user = Refinery::Authentication::Devise::User.from_omniauth(request.env["omniauth.auth"])
    # redirect_to refinery.authentication_devise_admin_users_path,
    #            :notice => t('created', :what => @user.username, :scope => 'refinery.crudify')
    sign_in_and_redirect @user
  end

  def failure
    logger.debug('###########################################')
    logger.debug(params)
    logger.debug(ENV["WECHAT_APP_CORP_ID"])
    logger.debug( ENV["WECHAT_APP_CORP_SECRET"])
    logger.debug(request.env.keys.sort)
    logger.debug(request.env["omniauth.error"])
    logger.debug(request.env["omniauth.error.type"])
    logger.debug('###########################################')
    redirect_to refinery.root_path
  end
end
