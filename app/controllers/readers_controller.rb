class ReadersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    begin
      reader_roles = ['Arc Reader', 'Beta Reader', 'Proof Reader']
      
      # Query users who have any of the reader roles through user_roles join table
      readers = User.joins(:user_roles)
                   .joins("JOIN roles ON roles.id = user_roles.role_id")
                   .where("roles.role IN (?)", reader_roles)
                   .distinct
                   .includes(:roles) # Include roles to avoid N+1 queries
      
      readers_data = readers.map do |user|
        {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          bio: user.bio,
          profile_picture: user.profile_picture,
          roles: user.roles.map { |r| { id: r.id, name: r.role } },
          charges_for_services: user.charges_for_services,
          facebook: user.facebook,
          instagram: user.instagram,
          x: user.x,
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      end
      
      render json: {
        success: true,
        readers: readers_data,
        count: readers_data.length
      }, status: :ok
      
    rescue => e
      Rails.logger.error "Error fetching readers: #{e.message}"
      render json: {
        success: false,
        error: 'Unable to fetch readers at this time'
      }, status: :internal_server_error
    end
  end
end