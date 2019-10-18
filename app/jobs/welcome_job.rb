class WelcomeJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Do something later
    WelcomeMailer.welcome_email(user).deliver

  end
end
