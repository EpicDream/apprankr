namespace :apprankr do
  namespace :reporter do

    desc "Daily report"
    task :daily => :environment do

      packages = ['fr.epicdream.beamy', 'com.agilys.moncaddy', 'com.shopmium', 'com.distribeo.scanbucks', 
                  'com.mtag.mobiletag', 'com.agilys.myshopi', 'com.phonegap.skooteco', 'com.fidall.novactive', 
                  'fr.snapp.fidme', 'com.plyce.client.fid', 'com.plyce.client', 'fr.bonial.android',
                  'com.scanbuy.flashcode', 'com.ezeeworld.qelmc']
      applications = Application.find_all_by_package(packages)
      Emailer.daily_summary(applications, 'elarch@gmail.com,thfrance@gmail.com', true).deliver     

      packages = ['com.florianmski.tracktoid']
      applications = Application.find_all_by_package(packages)
      Emailer.daily_summary(applications, 'florian.pub@gmail.com').deliver     

      packages = ['com.rasap.parisavant', 'com.rasap.nantesavant', 'com.rasap.metzavant', 
                  'com.historypin.Historypin', 'com.mtrip.Paris_fr', 'com.mtrip.Barcelona_fr']
      applications = Application.find_all_by_package(packages)
      Emailer.daily_summary(applications, 'contact@mavilleavant.com').deliver     

      packages = ['com.gares360']
      applications = Application.find_all_by_package(packages)
      Emailer.daily_summary(applications, 'android.sjambu@gmail.com').deliver     

      packages = [ 'com.twenga.twenga', 'de.idealo.android', 'com.pricerunner.android', 'com.mtag.mobiletag', 
                   'fr.epicdream.beamy', 'com.google.zxing.client.android', 'com.agilys.moncaddy' ]
      applications = Application.find_all_by_package(packages)
      Emailer.daily_summary(applications, 'alexandreserrurier@gmail.com').deliver     

    end

    task :test => :environment do
      packages = ['fr.epicdream.beamy']
      applications = Application.find_all_by_package(packages)
      Emailer.daily_summary(applications, 'elarch@gmail.com').deliver     
    end

  end
end
