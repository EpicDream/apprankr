=begin
require 'lib/console'
Console.user_stats 'elarch@gmail.com','bidibou$$1' 
=end

module Console
  require 'lib/scraper'
  require 'selenium-webdriver'

  def self.user_stats email, password
    login email, password
    stats = extract_stats
    extract_packages.each_with_index do |package, i|
      if package.eql?("fr.epicdream.likestorm")
        puts "ERROR: skipping #{package}"
        next
      end
      application = Application.find_by_package(package)
      if application.nil?
        puts "ERROR: impossible to find package #{package}"
        next
      end
      download = stats[i*2]
      install = stats[i*2+1]
      if download.nil?
        puts "ERROR: impossible to extract DOWNLOADS from #{package}"
        next
      end
      if install.nil?
        puts "ERROR: impossible to extract INSTALLATIONS from #{package}"
        next
      end
      application.add_report Report::DOWNLOADED, download.to_i
      application.add_report Report::INSTALLED, install.to_i
      puts "#{package} - Downloaded #{download} / Installed #{install}"
    end
  end

  def self.init
    @driver.quit if @driver
    @driver = Selenium::WebDriver.for :firefox
  end
  
  def self.login email, password
    init
    @driver.navigate.to "https://market.android.com/publish/Home"
    element = @driver.find_element(:name, 'Email')
    element.send_keys email
    element = @driver.find_element(:name, 'Passwd')
    element.send_keys password
    element.submit
    sleep 10
  end
  
  def self.extract_packages
    packages = []
    @driver.find_elements(:xpath, '//div[@class="listingRow"]/table/tbody/tr/td/div/a').each do |e|
      if m = e.attribute('href').match(/^https\:\/\/market\.android\.com\/publish\/Home#ViewCommentPlace\:p\=(.*)$/)
        packages << m[1]
      end
    end
    packages
  end
  
  def self.extract_stats
    stats = []
    @driver.find_elements(:xpath, '//div[@class="listingRow"]/div/div/span').each do |e|
      if m = e.text.match(/^([0-9,\.]+)$/)
        stats << m[1].gsub(/[^\d]/, "")
      end
    end
    stats
  end

end
