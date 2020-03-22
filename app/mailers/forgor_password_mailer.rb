class ForgorPasswordMailer < ApplicationMailer
    default from: 'samuelmonye00@gmail.com'

    def forgor_password(password, user)
      @password = password
      @user=user
      mail(to: @user.email, subject: 'Password reset for '+@user.name)
    end
end
