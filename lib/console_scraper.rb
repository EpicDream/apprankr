=begin
require 'lib/console_scraper'
scraper = ConsoleScraper.new
scraper.email='elarch@gmail.com'
scraper.password='bidibou$$1'
scraper.consoleIndex
=end

class ConsoleScraper
  require 'mechanize'

  attr_accessor :email, :password

  def initialize
    @agent = nil
    @login_done = false
  end
  
  def setup
    Mechanize.log = Logger.new("mechanize.log")
    Mechanize.log.level = Logger::DEBUG
    @agent = Mechanize.new
    if (@proxy_host && @proxy_host.length >= 1)
      @agent.set_proxy(@proxy_host, @proxy_port)
    end
  end

  # Login
  def login
    return if @login_done

    unless @agent
      setup
    end

    target_uri = 'https://market.android.com/publish/Home'

    @agent.get(target_uri)

    if (@agent.page.uri.host != "accounts.google.com" ||
        @agent.page.uri.path != "/ServiceLogin")
      STDERR.puts "Invalid login url... : uri = #{@agent.page.uri}"
      raise 'Google server connection error'
    end

    form = @agent.page.forms.find {|f| f.form_node['id'] == "gaia_loginform"}
    if (!form)
      raise 'No login form'
    end
    form.field_with(:name => "Email").value = @email
    form.field_with(:name => "Passwd").value = @password
    form.click_button

    if (@agent.page.uri.to_s != target_uri)
      STDERR.puts "login failed? : uri = " + @agent.page.uri.to_s
      raise 'Google login failed'
    end

    @login_done = true
  end

  def consoleIndex
    login
    url = 'https://market.android.com/publish/stats?type=APPDISTRIBUTION&app=fr.epicdream.beamy&tqx=reqId%3A1'
    referer = 'https://market.android.com/publish/Home'
    @agent.get(:url => url, :referer => referer)
    return @agent.page.body
  end

end
