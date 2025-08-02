class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_role!

  def index
    @users = User.all
    render json: @users
  end

  private

  def require_admin_role!
    render json: { error: 'Unauthorized' }, status: :forbidden unless current_user&.has_role?('Admin')
  end
end