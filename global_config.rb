# use nifty generator to create global config vars, accessible by APP_CONFIG[:some_setting]
# http://github.com/ryanb/nifty-generators/blob/master/rails_generators/nifty_config/USAGE
generate :nifty_config

#Overide yml created by nifty_config, to use expected tokens
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/config/app_config.yml > config/app_config.yml'


domain_development = ask("Dev domain [localhost:3001]?")
domain_development = "localhost:3000" if domain_development.blank?
domain_test = ask("Test domain [localhost:3001]?")
domain_test = "localhost:3000" if domain_test.blank?
domain_production = ask("Prod domain?")

source_file = File.expand_path(File.dirname(__FILE__)) + "/config/app_config.yml"

contents = ""
File.open(source_file, 'r') do |f1|  
   while line = f1.gets
     if line.include?("$")
       line.gsub!(/\$domain_development/, domain_development.to_s) if !line.nil?
       line.gsub!(/\$domain_test/, domain_test.to_s) if !line.nil?
       line.gsub!(/\$domain_production/, domain_production.to_s) if !line.nil?
     end
     contents += line  
   end  
end

File.open('config/app_config.yml', 'w') do |f2|   
 f2.puts contents
end