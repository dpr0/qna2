class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.lastday
    mail to: user.email, subject: 'Questions asked by the last day'
  end
end
