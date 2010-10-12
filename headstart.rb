gem "headstart", :version => '0.9.0'
gem 'formtastic', :version => '0.9.7'
gem 'will_paginate', :version => '2.2.2'
gem 'jammit', :version => '0.5.1'
gem 'fake_arel', :version => '0.7'

# Need to load this here. Otherwise the formtastic generator throws an error about the missing assets for Jammit
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/config/assets.yml > config/assets.yml'

generate(:formtastic)

plugin "iso-3166-country-select", :git => "git://github.com/rails/iso-3166-country-select.git"
plugin "enumerations_mixin", :git => "git://github.com/protocool/enumerations_mixin.git"
plugin "ar_fixtures", :git => "git://github.com/topfunky/ar_fixtures.git"

run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/ostruct_sql_query.rb > lib/ostruct_sql_query.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/email_validation.rb > lib/email_validation.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/url_validation.rb > lib/url_validation.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/formtastic_datepicker.rb > lib/formtastic_datepicker.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/config/initializers/requires.rb > config/initializers/requires.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/public/javascripts/application.js > public/javascripts/application.js'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/public/images/missing.jpg > public/images/missing.jpg'


generate :headstart


mailer_sender = ask("What is the mailer_sender? ")


if yes?("Do you want to use Delayed Job?")
  generate :delayed_job
  delayed_job = true
else
  delayed_job = false
end

source_file = File.expand_path(File.dirname(__FILE__)) + "/config/headstart.yml"

contents = ""
File.open(source_file, 'r') do |f1|  
   while line = f1.gets
     if line.include?("$")
       line.gsub!(/\$delayed_job/, delayed_job.to_s) if !line.nil?
       line.gsub!(/\$mailer_sender/, mailer_sender.to_s) if !line.nil?
     end
     contents += line  
   end  
end

File.open('config/headstart.yml', 'w') do |f2|   
 f2.puts contents
end


rake("db:migrate")

generate :headstart_admin



