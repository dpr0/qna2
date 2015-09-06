require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Questions asked by the last day")
      expect(mail.to).to eq(user.email)#(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Notification! Questions list created by 24 hours")
    end
  end

end
