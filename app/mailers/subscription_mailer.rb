class SubscriptionMailer < ApplicationMailer
  def notice(user, answer)
    @answer = answer
    mail to: user.email, subject: 'Answer created to monitored question'
  end
end
