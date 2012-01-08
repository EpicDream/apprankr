class Emailer < ActionMailer::Base

  # Emailer.daily_summary([Application.find(903)], 'elarch@gmail.com')
  def daily_summary applications, recipient
    @applications = applications
    mail(:to => recipient, :subject => "Daily report from Apprankr", :from => "Apprankr <apprankr@prixing.fr>")
  end

end
