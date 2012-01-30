# Load the rails application
require File.expand_path('../application', __FILE__)

# Specific singularization
ActiveSupport::Inflector.inflections do |inflect|  
  inflect.irregular 'whatsnew', 'whatsnews'
end

# Initialize the rails application
Apprankr::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  #:address              => "smtp.epicdream.fr",
  :address              => "localhost",
  :port                 => 25,
  :domain               => "prixing.fr"
}
