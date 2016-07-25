module Refinery
  module Authentication
    module Devise
      class CallbacksController < Devise::OmniauthCallbacksController
        def wechat_qiye
          @user = User.from_omniauth(request.env["omniauth.auth"])
          sign_in_and_redirect @user
        end
      end
    end
  end
end
