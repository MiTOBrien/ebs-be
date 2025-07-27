class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name username roles])

    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name username professional roles bio profile_picture facebook instagram x])
  end
end
