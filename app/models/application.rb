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
  has_many :reports
  belongs_to :category

  validates :package, :presence => true

  def ranking_types
    RankingType.where(:id => self.rankings.where("ranks.created_at::date+1>=now()::date").map(&:ranking_type_id).uniq)
  end

  def ranking_countries
    Country.where(:id => self.rankings.uniq.map(&:country_id)).order(:name)
  end

  def ranking_categories_for_country country
    Category.where(:id => self.ranks.joins(:ranking).where("rankings.country_id=#{country.id}").select("distinct category_id").map(&:category_id)).order(:id)
  end

  def ranking_types_for_country_and_category country, category
    RankingType.where(:id => self.ranks.joins(:ranking).where("rankings.country_id=#{country.id} and rankings.category_id=#{category_id}").select("distinct ranking_type_id").map(&:ranking_type_id)).order(:id)
  end

  def ranking_types_for_country country
    RankingType.where(:id => self.ranks.joins(:ranking).where("rankings.country_id=#{country.id}").select("distinct ranking_type_id").map(&:ranking_type_id)).order(:id)
  end
  
  def current_rank ranking
    self.ranks.where("ranking_id=? and created_at::date+1>=now()::date", ranking.id).order("created_at desc").first
  end

  def previous_rank ranking
    self.ranks.where("ranking_id=? and created_at::date+2>=now()::date", ranking.id).order("created_at desc").second
  end

  def current association, language
    language ||= Language.find_by_code('fr')
    send(association).where(:language_id => language.id).order("created_at desc").first \
      || send(association).order("created_at desc").first
  end

  def day_report stat, delay=0
    today = self.reports.where("stat=#{stat} and created_at::date=now()::date-interval '#{delay} days'").pop.try(:value)
    yesterday = self.reports.where("stat=#{stat} and created_at::date=now()::date-interval '#{delay+1} days'").pop.try(:value)
    today.nil? ? nil : today - (yesterday.nil? ? 0 : yesterday)
  end

  def report stat, delay=0
    self.reports.where("stat=#{stat} and created_at::date=now()::date-interval '#{delay} days'").pop.try(:value) || "N/A"
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
  
  def previous_version
    self.versions.order("created_at desc").second
  end
  
  def download
    self.downloads.order("created_at desc").first
  end

  def previous_download
    self.downloads.order("created_at desc").second
  end
  
  def review_summary
    self.review_summaries.order("created_at desc").first
  end
  
  def last_reviews
    self.reviews.where("updated_at::date=now()::date-1").order(:updated_at)
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
  
  def add_report stat, value
    return if stat.nil? || value.nil?
    r = Report.where("application_id=#{self.id} and stat=#{stat} and date(created_at)=date(now())").first
    if r.nil?
      Report.create(:stat => stat, :value => value, :application => self)
    else
      r.update_attribute :value, value
    end
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
  
  def last_changes
    v = self.versions.where("created_at::date=now()::date-1")
    t = self.titles.where("created_at::date=now()::date-1")
    s = self.descriptions.where("created_at::date=now()::date-1")
    w = self.whatsnews.where("created_at::date=now()::date-1")
    d = self.downloads.where("created_at::date=now()::date-1")
    { :version => v.size > 1 ? v.first : nil,
      :title => t.size > 1 ? t.first : nil,
      :description => s.size > 1 ? s.first : nil,
      :whatsnew => w.size > 1 ? w.first : nil,
      :download => d.size > 1 ? d.first : nil, }
  end
  
end
