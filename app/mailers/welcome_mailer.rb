class WelcomeMailer < ApplicationMailer
    default from: 'samuelmonye00@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Fireball '+@user.name)
  end
end
