# require 'lib/scraper'; Scraper.scrape
# doc = Nokogiri::HTML(`curl --silent https://market.android.com/details?id=apps_topselling_paid&cat=APPLICATION`)
=begin
doc = Scraper.get("https://market.android.com/details?id=fr.epicdream.beamy&hl=fr")
a=Application.find(904)
Scraper.scrape_application_page a

=end

module Scraper
  require 'yaml'
  require 'uri'
  require 'net/http'
  require 'nokogiri'
  require 'htmlentities'

  @log = ""

  def self.scrape_application_page application
    log "Updating application #{application.package}"
    updated = false
    Language.where(:scrape => true).each do |language|
      doc = get("https://market.android.com/details?id=#{application.package}&hl=#{language.code}")
      next if doc.xpath("//div[@class='doc-banner-icon']/img").count == 0 || doc.xpath("//div[@class='doc-banner-icon']/img").attribute('src').to_s.blank?
      # reviews
      reviews = doc.xpath("//div[@class='doc-review']")
      scrape_reviews application, language if reviews.count > 0
      # update app data
      if !updated
        application.update_attribute :developer, HTMLEntities.new.decode(doc.xpath("//a[@class='doc-header-link']").children.to_s)
        application.update_attribute :icon, doc.xpath("//div[@class='doc-banner-icon']/img").attribute('src').to_s
        video = doc.xpath("//param[@name='movie']")
        application.update_attribute :video, video.attribute("value").to_s if video.count > 0
        data = doc.xpath("//a[@class='more-arrow-link'][@rel='nofollow']")
        application.update_attribute :website, data[0].attribute('href').to_s if data[0] && data[0].count > 0
        application.update_attribute :email, data[1].attribute('href').to_s.gsub!(/mailto\:/, "") if data[1] && data[1].count > 0
        screenshots = []
        doc.xpath("//div[@class='screenshot-carousel-content-container']/img").each do |img|
          screenshots << img.attribute("src").to_s
        end
        application.update_attribute :screenshots, screenshots.join(",")      
        version = HTMLEntities.new.decode(doc.xpath("//dd[@itemprop='softwareVersion']").children.to_s)   
        size = HTMLEntities.new.decode(doc.xpath("//dd[@itemprop='fileSize']").children.to_s) 
        price = HTMLEntities.new.decode(doc.xpath("//meta[@itemprop='price']").attribute('content').to_s)
        price_micro = price.gsub(/[^\d]/, "").to_i
        price = "free" if price_micro == 0
        if application.price.blank? || !application.price.value.eql?(price)
          log "  PRICE: #{price} (#{price_micro})"
          application.add_price price_micro, price, Country.france.pop
        end
        if application.version.blank? || !application.version.value.eql?(version)
          log "  VERSION: #{version}"
          application.add_version version, size
        end
        download = HTMLEntities.new.decode(doc.xpath("//dd[@itemprop='numDownloads']").children.first.to_s)
        if application.download.blank? || !application.download.value.eql?(download)
          log "  DOWNLOAD: #{download}"
          application.add_download download
        end
        star = 4
        votes = []
        doc.xpath("//div[@id='details-tab-2']/div/div/div/table/tr/td/span").each do |e|
          if m = e.to_s.match(/^<span>(.*)<\/span>$/)
            votes[star] = m[1].gsub(/[^\d]/, '').to_i
            star -= 1
          end
        end
        if application.add_review_summary votes
          total = 0
          votes.each_with_index { |e,i| total += e*(i+1) }
          average = total.to_f / votes.sum
          log "  RATING: #{sprintf("%1.2f", average)}"
        end
        updated = true
      end
      description = HTMLEntities.new.decode(doc.xpath("//div[@id='doc-original-text']").children.to_s)
      if application.description(language).blank? || !application.description(language).content.eql?(description)
        log "  [#{language.name}] DESCRIPTION: #{description.first(50)}"
        application.add_description description, language
      end     
      title = HTMLEntities.new.decode(doc.xpath("//h1").children.to_s)
      if application.title(language).blank? || !application.title(language).content.eql?(title)
        log "  [#{language.name}] TITLE: #{title.first(50)}"
        application.add_title title, language
      end
      whatsnew = HTMLEntities.new.decode(doc.xpath("//div[@class='doc-whatsnew-container']").children.to_s)
      whatsnew.gsub!(/\n/, " ")
      if application.whatsnew(language).blank? || !application.whatsnew(language).content.eql?(whatsnew)
        log "  [#{language.name}] WHATSNEW: #{whatsnew.first(50)}"
        application.add_whatsnew whatsnew, language
      end 
    end
  end

=begin
require 'lib/scraper'
l = Language.find_by_code("fr")
a = Application.find_by_package("fr.epicdream.beamy")
Scraper.scrape_reviews a ,l
=end
  def self.scrape_reviews application, language
    count = 0
    page = 0
    begin
      max = 0
      json = `curl --silent -d 'id=#{application.package}&reviewSortOrder=0&reviewType=1&pageNum=#{page}&hl=#{language.code}' 'https://market.android.com/getreviews'`
      json.gsub!(/\\u003C/, "<")
      json.gsub!(/^\)\]\}\'/, "")
      begin
        hash = JSON.parse json
        max = hash['numPages']
        doc = Nokogiri::HTML(hash['htmlContent'])
        reviews = doc.xpath("//div[@class='doc-review']")
        reviews.each do |review|
          found = scrape_review review, application, language
          if found
            page = 999
            break
          else
            count += 1
          end
        end
      rescue Exception => e
        puts "ERROR #{e.inspect}"
        page = 999
      end
      page += 1
    end while page <= max
    log "  [#{language.name}] #{count} reviews" if count > 0
  end

=begin
require 'lib/scraper'
doc=Scraper.get("https://market.android.com/details?id=fr.epicdream.beamy&hl=fr")
reviews = doc.xpath("//div[@class='doc-review']")
review = reviews.first
l = Language.find_by_code("fr")
a = Application.find_by_package("fr.epicdream.beamy")
Scraper.scrape_review review, a ,l
=end
  def self.scrape_review review, application, language
    author = HTMLEntities.new.decode(review.xpath("*[@class='doc-review-author']/strong").children.to_s)
    title = HTMLEntities.new.decode(review.xpath("*/h4[@class='review-title']").children.to_s)
    content = HTMLEntities.new.decode(review.xpath("*[@class='review-text']").children.to_s)
    rating = review.xpath("*/div[@class='ratings goog-inline-block']").attribute("title").to_s.match(/([0-9,\.]+)/)[1].gsub!(/[^\d]/, "").to_i.div(10)
    date = HTMLEntities.new.decode(review.xpath("*[@class='doc-review-date']").children.to_s).downcase
    date = translate_date date, language if !language.name.eql?('English')
    signature = review.xpath("*/a").attribute("href").to_s.match(/reviewId=([\d]+)/)[1]
    begin
      r = Review.new(
        :signature => signature, 
        :application => application,
        :language => language,
        :author => author,
        :title => title,
        :content => content,
        :rating => rating,
        :created_at => "#{Date.parse(date)} 15:00:00",
        :updated_at => "#{Date.parse(date)} 15:00:00" )
      if r.save
        return false
      else
        log "  #{HTMLEntities.new.decode(review.xpath("*[@class='doc-review-date']").children.to_s)} ==> #{Date.parse(date)}"
        log "  ERROR: #{r.errors.full_messages.join(", ")}"
        return true
      end
    rescue
      return true
    end
  end

  def self.scrape
    init
    Country.all.each do |country|
      scrape_country country
    end
  end

  def self.scrape_country country
    init
    Category.all.each do |category|
      RankingType.all.each do |ranking_type|
        ranking = Ranking.find_or_create_by_country_id_and_category_id_and_ranking_type_id(country.id, category.id, ranking_type.id)
        scrape_ranking ranking, country
      end
    end
  end
  
  def self.scrape_ranking ranking, country
    n = 0
    rank = 0
    proxy = {}
    proxy[:host], proxy[:port], proxy[:user], proxy[:pass] = @config['proxy'][country.name].split(/\:/) unless @config['proxy'][country.name].nil?
    Rank.destroy_all("date(created_at) = date(now()) and ranking_id=#{ranking.id}")
    begin
      #puts "#{country.name} #{ranking.category.name} #{ranking.ranking_type.name} #{rank}"
      if ranking.category.name.eql?("APPLICATION")
        doc = get("https://market.android.com/details?id=#{ranking.ranking_type.name}&start=#{rank}", proxy)
      else
        doc = get("https://market.android.com/details?id=#{ranking.ranking_type.name}&cat=#{ranking.category.name}&start=#{rank}", proxy)
      end
      doc.xpath("//li[@class='goog-inline-block']").each do |widget|
        app_data = widget.xpath("div/div/div/div/div[contains(@class,'buy-border')]/a")
        application = scrape_application_widget app_data, country, ranking
        r = widget.xpath("div/div/div/div/div[@class='ordinal-value']").children.to_s
        if r.blank?
          rank += 1
        else
          rank = r.to_i
        end
        Rank.create(:application => application, :ranking => ranking, :rank => rank)
      end
      n += 1
    end while doc.xpath("//*[contains(@class,'num-pagination-next')]").count > 0 && n <= 20 
  end

  def self.scrape_application_widget app_data, country, ranking
    package = app_data.xpath("@data-docid").children.to_s
    application = Application.find_or_create_by_package(package)
    if application.title(country.language).nil? || application.category.nil?
      application.add_title HTMLEntities.new.decode(app_data.xpath("@data-doctitle").children.to_s), country.language
      application.add_price app_data.xpath("@data-docpricemicros").children.to_s.to_i, app_data.xpath("@data-docprice").children.to_s, country
      application.update_attribute :developer, HTMLEntities.new.decode(app_data.xpath("@data-docattribution").children.to_s)
      application.update_attribute :icon, app_data.xpath("@data-dociconurl").children.to_s
      if !ranking.category.name.eql?('APPLICATION') && !ranking.category.name.eql?('GAME')
        application.update_attribute :category, ranking.category
      end
    end
    application
  end  

  def self.init
    @config = YAML.load(File.open("#{Rails.root}/lib/config.yml"))
    @config['languages'].each do |lg|
      code, name = lg.split(/\:/)
      Language.find_or_create_by_code_and_name(code, name)
    end
    @config['countries'].each do |country|
      name, lg_code, code = country.split(/\:/)
      c = Country.find_or_create_by_name_and_language_id(name, Language.find_by_code(lg_code).id)
      c.update_attribute :code, code
    end
    @config['categories'].each do |category_name|
      Category.find_or_create_by_name category_name
    end
    @config['ranking_types'].each do |ranking_type_name|
      RankingType.find_or_create_by_name ranking_type_name
    end
  end

  def self.get url, proxy={}
=begin
    begin
      uri = URI.parse url
      Net::HTTP.start(uri.host, uri.port, proxy[:host], proxy[:port], proxy[:user], proxy[:pass], { :use_ssl => true }) do |http|
        response = http.get(uri.request_uri)
        return Nokogiri::HTML(response.body)
      end
    rescue Exception => e
      self.log "Failed to get #{url}\n#{e.inspect}"
    end
=end
    if proxy[:host].nil? 
      body = `curl --silent '#{url}'`
    else
      body = `curl --silent --proxy #{proxy[:host]}:#{proxy[:port]} --proxy-user #{proxy[:user]}:#{proxy[:pass]} '#{url}'`
    end    
    return Nokogiri::HTML(body)
  end
  
  def self.log log = ""
    newline = "[#{Time.now.to_s(:timestamp)}] #{log}"
    @log += "#{newline}\n" unless log.blank?
    puts newline unless log.blank?
    @log
  end

  def self.post url, params
    begin
      uri = URI.parse url
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params)
      return http.request(request)
		rescue Exception => e
			#self.log "Failed to Net::HTTP #{url}\n#{e.inspect}"
			nil
		end
	end

  def self.translate_date date, language
    @month = YAML.load(File.open("#{Rails.root}/lib/month.yml")) unless @month
    @month[language.name].each_with_index do |m,i|
      date.gsub!(m, @month['English'][i])
      date.gsub!(" de ", " ")
    end
    date
  end

end
