class Emailer < ActionMailer::Base

  default :from => "apprankr@prixing.fr"

  def daily_summary applications, recipient, reporting=false
    @reporting = reporting
    @applications = applications
    mail(:to => recipient, :subject => "[Apprankr] Daily report for #{Date.yesterday.to_s(:long)}", :from => "apprankr@prixing.fr")
  end

end
