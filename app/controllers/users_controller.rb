class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_role!, only: [:index]
  before_action :set_user, only: [:update]

  def index
    @users = User.all
    render json: @users
  end

  def update
    if @user.update(user_params)
    
      save_user_roles(@user) if params[:user][:roles].present?

      if params[:user][:genre_ids]
        genre_ids = params[:user][:genre_ids].reject(&:blank?)
        @user.genres = Genre.where(id: genre_ids)
      end

      render json: @user.as_json(include: { roles: { only: [:id, :role] }, genres: { only: [:id, :name] } }), status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

    def change_password
    # Validate current password
    unless current_user.valid_password?(password_change_params[:current_password])
      return render json: { error: 'Current password is incorrect.' }, status: :unauthorized
    end

    # Validate new password confirmation
    if password_change_params[:new_password] != password_change_params[:new_password_confirmation]
      return render json: { error: 'New password confirmation does not match.' }, status: :unprocessable_entity
    end

    # Update password
    if current_user.update(password: password_change_params[:new_password])
      render json: { message: 'Password changed successfully.' }, status: :ok
    else
      render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def require_admin_role!
    render json: { error: 'Unauthorized' }, status: :forbidden unless current_user&.has_role?('Admin')
  end

  def set_user
    @user = current_user
  end

  def password_change_params
    params.permit(:current_password, :new_password, :new_password_confirmation)
  end

  def user_params
    params.require(:user).permit(
      :username,
      :first_name,
      :last_name,
      :bio,
      :facebook,
      :instagram,
      :x,
      :charges_for_services,
      :profile_picture,
      role_ids: [],
      genre_ids: [],
      pricing_tiers_attributes: [:id, :word_count, :price_cents, :currency, :_destroy]
    )
  end

  def save_user_roles(user)
    role_ids = params[:user][:role_ids].reject(&:blank?)
    roles = Role.where(id: role_ids)

    user.user_roles.destroy_all
    roles.each do |role|
      user.user_roles.create!(role: role)
    end
  rescue => e
    Rails.logger.error "Failed to update roles for user #{user.id}: #{e.message}"
  end
end