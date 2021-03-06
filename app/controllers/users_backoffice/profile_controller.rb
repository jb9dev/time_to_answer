module UsersBackoffice
  class ProfileController < UsersBackofficeController
    before_action :set_user
    before_action :extract_passwords, only: %i[update]

    def edit
      @user.build_user_profile if @user.user_profile.blank?
    end

    def update
      if @user.update(user_params)
        bypass_sign_in @user
        unless params[:user][:user_profile_attributes][:avatar]
          redirect_to users_backoffice_profile_url, notice: I18n.t('messages.success.update', item: @user.email)
        end
      else
        render :edit
      end
    end

    private

    def extract_passwords
      params[:user].extract!(:password, :password_confirmation) if empty_passwords?
    end

    def empty_passwords?
      params[:user][:password].blank? && params[:user][:password_confirmation].blank?
    end

    def set_user
      @user = User.find(current_user.id)
    end

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :password,
        :password_confirmation,
        user_profile_attributes: %i[id zip_code address gender birthdate avatar]
      )
    end
  end
end
