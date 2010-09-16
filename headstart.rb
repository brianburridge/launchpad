gem "headstart", :version => '0.6.0'
gem 'formtastic', :version => '0.9.7'
gem 'will_paginate', :version => '2.2.2'
gem 'jammit', :version => '0.5.1'

plugin "enumerations_mixin", :git => "git://github.com/protocool/enumerations_mixin.git"
plugin "ar_fixtures", :git => "git://github.com/topfunky/ar_fixtures.git"

run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/ostruct_sql_query.rb > lib/ostruct_sql_query.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/email_validation.rb > lib/email_validation.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/url_validation.rb > lib/url_validation.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/lib/formtastic_datepicker.rb > lib/formtastic_datepicker.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/config/initializers/requires.rb > config/initializers/requires.rb'
run 'curl -L http://github.com/bburridge/launchpad/raw/master/template/config/assets.yml > config/assets.yml'

# Set up session store initializer
=begin
initializer 'requires.rb', <<-END
require 'formtastic_datepicker'
require 'ostruct_sql_query'
require 'email_validation'
require 'url_validation'
END
=end

generate :headstart

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
     end
     contents += line  
   end  
end

File.open('config/headstart.yml', 'w') do |f2|   
 f2.puts contents
end


rake("db:migrate")

generate :headstart_admin

