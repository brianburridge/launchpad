if yes?("Do you want to use Facebook for user authentication?")
  use_facebook_connect = true
  run 'curl -L https://github.com/bburridge/launchpad/raw/master/template/public/images/facebook_login.png > public/images/facebook_login.png'
  gem 'mini_fb', :version => '1.1.3'
else
  use_facebook_connect = false
end

if use_facebook_connect
  facebook_api_key = ask("API Key?")
  facebook_secret_key = ask("Secret Key?")
  facebook_app_id = ask("App ID?")
end

source_file = File.expand_path(File.dirname(__FILE__)) + "/config/headstart.yml"

contents = ""
File.open(source_file, 'r') do |f1|  
   while line = f1.gets
     if line.include?("$")
       line.gsub!(/\$use_facebook_connect/, use_facebook_connect.to_s) if !line.nil?
       line.gsub!(/\$facebook_api_key/, facebook_api_key.to_s) if !line.nil?
       line.gsub!(/\$facebook_secret_key/, facebook_secret_key.to_s) if !line.nil?
       line.gsub!(/\$facebook_app_id/, facebook_app_id.to_s) if !line.nil?
     end
     contents += line  
   end  
end

File.open('config/headstart.yml', 'w') do |f2|   
 f2.puts contents
end