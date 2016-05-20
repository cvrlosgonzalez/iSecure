class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :pnumber)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :pnumber)
  end
end
