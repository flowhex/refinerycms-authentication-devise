module Refinery
  module Authentication
    module Devise
      class PasswordsController < ::Devise::PasswordsController
        helper Refinery::Core::Engine.helpers
        layout 'refinery/layouts/login'

        before_action :store_password_reset_return_to, :only => [:update]
        def store_password_reset_return_to
          session[:'return_to'] = Refinery::Core.backend_path
        end
        protected :store_password_reset_return_to

        # Rather than overriding devise, it seems better to just apply the notice here.
        after_action :give_notice, :only => [:update]
        def give_notice
          if %w(notice error alert).exclude?(flash.keys.map(&:to_s)) or self.resource.errors.any?
            flash[:notice] = t('successful', :scope => 'refinery.authentication.devise.users.reset', :email => self.resource.email)
          end
        end
        protected :give_notice

        # GET /registrations/password/edit?reset_password_token=abcdef
        def edit
          if @reset_password_token = params[:reset_password_token]
            self.resource = User.find_or_initialize_with_error_by_reset_password_token(params[:reset_password_token])
            respond_with(self.resource) and return
          end

          redirect_to refinery.new_authentication_devise_user_password_path,
                      :flash => ({ :error => t('code_invalid', :scope => 'refinery.authentication.devise.users.reset') })
        end

        # POST /registrations/password
        def create
          if params[:authentication_devise_user].present? && (email = params[:authentication_devise_user][:email]).present? &&
             (user = User.where(:email => email).first).present?

            token = user.generate_reset_password_token!
            UserMailer.reset_notification(user, request, token).deliver_now
            redirect_to refinery.login_path,
                        :notice => t('email_reset_sent', :scope => 'refinery.authentication.devise.users.forgot')
          else
            flash.now[:error] = if (email = params[:authentication_devise_user][:email]).blank?
              t('blank_email', :scope => 'refinery.authentication.devise.users.forgot')
            else
              t('email_not_associated_with_account_html', :email => ERB::Util.html_escape(email), :scope => 'refinery.authentication.devise.users.forgot').html_safe
            end

            self.new

            render :new
          end
        end
      end
    end
  end
end
