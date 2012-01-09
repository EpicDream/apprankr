namespace :apprankr do
  namespace :selenium do

    desc "Scrape user's application download"
    task :console => :environment do
      require './lib/console'
      `export DISPLAY=:99`
      Console.user_stats 'elarch@gmail.com','bidibou$$1' 
    end
    
  end
end
