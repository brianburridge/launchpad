if yes?("Do you want to backup the db to amazon s3?")
  
  access_key_id = ask("Enter Amazon S3 Access Key ID: ")
  secret_access_key = ask("Enter Amazon S3 Secret Access Key: ")
  bucket = ask("Enter Amazon S3 bucket for backups: ")
  
file "config/initializers/db2s3.rb", <<-END
  DB2S3::Config.instance_eval do
      S3 = {
        :access_key_id     => '#{access_key_id}',
        :secret_access_key => '#{secret_access_key}',
        :bucket            => '#{bucket}'
      }
  end
END

  # Add db2s3 to Rakefile
  contents = ""
  %w(
  Rakefile
  ).each do |source_file|
    File.open(source_file, 'r') do |f1|  
       while line = f1.gets
         contents += line  
       end  
    end

    File.open(source_file, 'w') do |f2|   
     f2.puts contents
     f2.puts "require 'db2s3/tasks'"
    end
  end

  run 'curl -L https://github.com/bburridge/launchpad/raw/master/template/config/schedule.rb > config/schedule.rb'
  
  using_whenever = false
  if yes?("Do you want to use the whenever gem to run these backups and other crons? (Does not work on heroku) ")
    gem 'whenever', :version => '0.4.1', :lib => false, :source => 'http://gemcutter.org/'
    gem "db2s3", :version => '0.3.1', :source => "http://gemcutter.org"
    
    base_dir = ask("What directory will the app be stored in the server (ex. /var/www/peepnote) - no trailing slash ")
    
    output = base_dir + '.#{environment}.cron.log'
    app_current_dir = base_dir + '/current'
    app_base_dir_prod = base_dir + "/"
    app_base_dir_prod.gsub!(/\//) {|s| "\\/" + s[1].to_s}
    app_base_dir_staging = base_dir + '.staging/'
    app_base_dir_staging.gsub!(/\//) {|s| "\\/" + s[1].to_s}
    
    using_whenever = true

    source_file = File.expand_path(File.dirname(__FILE__)) + "/config/schedule.rb"

    contents = ""
    File.open(source_file, 'r') do |f1|  
       while line = f1.gets
         if line.include?("$")
           # Note, using single quotes because we do not want to replace environment when writing this out
           line.gsub!(/\$output/, output) if !line.nil?
           line.gsub!(/\$app_current_dir/, app_current_dir) if !line.nil?
           line.gsub!(/\$app_base_dir_prod/, app_base_dir_prod) if !line.nil?
           line.gsub!(/\$app_base_dir_staging/, app_base_dir_staging) if !line.nil?
         end
         contents += line  
       end  
    end

    File.open('config/schedule.rb', 'w') do |f2|   
     f2.puts contents
    end
    
  end

  if !using_whenever

  end
  
end