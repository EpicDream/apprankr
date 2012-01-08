# Load the rails application
require File.expand_path('../application', __FILE__)

# Specific singularization
ActiveSupport::Inflector.inflections do |inflect|  
  inflect.irregular 'whatsnew', 'whatsnews'
end

# Initialize the rails application
Apprankr::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.epicdream.fr",
  :port                 => 25,
  :domain               => "prixing.fr"
}
