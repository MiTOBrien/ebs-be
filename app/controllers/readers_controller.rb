class ReadersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    begin
      reader_roles = ['arcreader', 'betareader', 'proofreader']
      
      # Query users who have any of the reader roles
      # Adjust this query based on how your roles are stored:
      
      # If roles is a PostgreSQL array:
      readers = User.where("roles && ARRAY[?]::varchar[]", reader_roles)
      
      # If roles is a JSON array:
      # readers = User.where("JSON_EXTRACT(roles, '$[*]') REGEXP ?", reader_roles.join('|'))
      
      # If roles is stored as comma-separated string:
      # readers = User.where("roles REGEXP ?", reader_roles.join('|'))
      
      readers_data = readers.map do |user|
        {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          bio: user.bio,
          profile_photo: user.profile_photo,
          roles: user.roles,
          charges_for_services: user.charges_for_services,
          facebook_handle: user.facebook_handle,
          instagram_handle: user.instagram_handle,
          x_handle: user.x_handle,
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