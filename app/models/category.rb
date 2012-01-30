class Category < ActiveRecord::Base
  has_many :applications
  
  def true_name
    self.name.eql?("APPLICATION") ? "GENERAL" : self.name
  end
  
end
