namespace :apprankr do

  desc "Scrape all monitored applications"
  task :applications => :environment do
    require './lib/scraper'
    Application.where(:monitor => true).each do |application|
      Scraper.scrape_application_page application
    end
  end

  desc "Scrape France, Germany, Netherlands"
  task :countries1 => :environment do
    require './lib/scraper'
    Scraper.scrape_country Country.find_by_name("France")
    Scraper.scrape_country Country.find_by_name("Germany")
    Scraper.scrape_country Country.find_by_name("Netherlands")
  end

  desc "Scrape United Kingdom, Denmark, Sweden"
  task :countries2 => :environment do
    require './lib/scraper'
    Scraper.scrape_country Country.find_by_name("United Kingdom")
    Scraper.scrape_country Country.find_by_name("Sweden")
    Scraper.scrape_country Country.find_by_name("Denmark")
  end

  desc "Scrape Austria, USA, Brazil"
  task :countries3 => :environment do
    require './lib/scraper'
    Scraper.scrape_country Country.find_by_name("Austria")
    Scraper.scrape_country Country.find_by_name("USA")
    Scraper.scrape_country Country.find_by_name("Brazil")
  end

end
