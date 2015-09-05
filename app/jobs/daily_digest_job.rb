class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    #User.send_daily_digest
    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
