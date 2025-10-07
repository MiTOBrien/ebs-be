class Users::PasswordsController < ApplicationController
  def create
    if params[:user][:email].blank?
      return render json: { error: 'Email not present' }, status: :bad_request
    end

    user = User.find_by(email: params[:user][:email])
    if user
      user.send_reset_password_instructions
      render json: { message: 'Reset instructions sent to your email.' }, status: :ok
    else
      render json: { error: 'Email not found' }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s

    user = User.reset_password_by_token(
      reset_password_token: token,
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if user.errors.empty?
      render json: { message: 'Password has been reset.' }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end