class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      # Save user roles after successful user creation
      save_user_roles(resource) if params[:user][:role_ids].present?
      
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      UserMailer.welcome_email(resource).deliver_later
      
      render json: {
        status: { code: 200, message: 'Signed up successfully.',
                  token: @token,
                  data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }
    else
      Rails.logger.debug "Signup failed: #{resource.errors.full_messages}"

      message = if resource.errors[:email].any? || resource.errors[:username].any?
                  "Email or username is already taken."
                else
                  resource.errors.full_messages.to_sentence
                end

      render json: {
        status: { message: "User couldn't be created successfully. #{message}" }
      }, status: :unprocessable_entity
      # render json: {
      #   status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      # }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation, 
                                 :tos_accepted, role_ids: [])
  end


  def save_user_roles(user)
    role_ids = params[:user][:role_ids]

    if role_ids.present?
      role_ids.each do |role_id|
        role = Role.find_by(id: role_id)
        if role
          user.user_roles.create!(role: role)
        else
          Rails.logger.error "Role ID not found: #{role_id}"
        end
      end
    else
      Rails.logger.warn "No role_ids provided for user #{user.id}"
    end
  rescue => e
    Rails.logger.error "Failed to save roles for user #{user.id}: #{e.message}" 
  end
end