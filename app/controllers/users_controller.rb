class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_role!, only: [:index]
  before_action :set_user, only: [:update]

  def index
    @users = User.all
    render json: @users
  end

  def update
    if @user.update(user_params)
      update_roles if params[:user][:roles]
      render json: @user.as_json(include: { roles: { only: :role } }), status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def require_admin_role!
    render json: { error: 'Unauthorized' }, status: :forbidden unless current_user&.has_role?('Admin')
  end

  def set_user
    @user = current_user
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
      :profile_picture
    )
  end

  def update_roles
    role_names = params[:user][:roles].map(&:downcase)
    roles = Role.where('LOWER(role) IN (?)', role_names)
    @user.roles = roles
  end
end
