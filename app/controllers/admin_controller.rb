class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def role_summary
  begin
    target_roles = ['Author', 'Arc Reader', 'Beta Reader', 'Proof Reader']

    # Get role records for target roles
    roles = Role.where(role: target_roles)

    # Build summary by counting users per role_id
    summary = roles.map do |role|
      {
        role: role.role,
        role_id: role.id,
        count: User.joins(:user_roles).where(user_roles: { role_id: role.id }).distinct.count
      }
    end

    render json: { summary: summary }, status: :ok

  rescue => e
    Rails.logger.error "Error generating role summary: #{e.message}"
    render json: {
      success: false,
      error: 'Unable to generate role summary'
    }, status: :internal_server_error
  end
end

  private

  def ensure_admin!
    redirect_to root_path unless current_user&.has_role?('Admin')
  end
end