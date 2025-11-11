class UserMailer < ApplicationMailer
  default from: 'noreply@earlydraftsociety.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Early Draft Society!')
  end
end
