class Application < ActiveRecord::Base
  has_many :titles
  has_many :descriptions
  has_many :whatsnews
  has_many :versions
  has_many :prices
  has_many :downloads
  has_many :reviews
  has_many :review_summaries
  has_many :ranks
  has_many :rankings, :through => :ranks
  belongs_to :category

  validates :package, :presence => true

  def current association, language
    language ||= Language.find_by_code('fr')
    send(association).where(:language_id => language.id).order("created_at desc").first \
      || send(association).order("created_at desc").first
  end

  def title language=nil
    current :titles, language
  end

  def description language=nil
    current :descriptions, language
  end

  def whatsnew language=nil
    current :whatsnews, language
  end

  def price country=Country.find_by_name('France')
    p = self.prices.where(:country_id => country.id).order("created_at desc").first
    if p.nil?
      return self.prices.order("created_at desc").first
    else
      return p
    end
  end

  def version
    self.versions.order("created_at desc").first
  end
  
  def download
    self.downloads.order("created_at desc").first
  end
  
  def add_title content, language
    Title.create(:content => content, :application => self, :language => language)
  end

  def add_description content, language
    Description.create(:content => content, :application => self, :language => language)
  end

  def add_whatsnew content, language
    Whatsnew.create(:content => content, :application => self, :language => language)
  end

  def add_price amount, value, country
    value = "free" if amount == 0
    Price.create(:value => value, :application => self, :country => country)
  end

  def add_version value, size
    Version.create(:value => value, :size => size, :application => self)
  end
  
  def add_download value
    Download.create(:value => value, :application => self)
  end
  
  def add_review_summary votes
    r = ReviewSummary.find_or_initialize_by_application_id_and_star1_and_star2_and_star3_and_star4_and_star5(self.id, votes[0], votes[1], votes[2], votes[3], votes[4])
    if r.id
      r.touch
      return false
    else
      r.save
      return true
    end
  end
    
end
