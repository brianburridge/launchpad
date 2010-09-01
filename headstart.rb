gem "cops", :version => '0.2.0.7', :lib => 'blue_light_special'
gem 'formtastic'
gem 'will_paginate'
# must use paperclip 2.3.0 at this point due to conflict between aws-s3 (needed by paperclip 2.3.1 and right_aws needed by backup_fu plugin)
gem 'paperclip', :version => '2.3.0'
gem 'right_aws'
  
generate :blue_light_special

if yes?("Do you want to use Delayed Job?")
  generate :delayed_job
  delayed_job = true
else
  delayed_job = false
end

source_file = File.expand_path(File.dirname(__FILE__)) + "/config/blue_light_special.yml"

contents = ""
File.open(source_file, 'r') do |f1|  
   while line = f1.gets
     if line.include?("$")
       line.gsub!(/\$delayed_job/, delayed_job.to_s) if !line.nil?
     end
     contents += line  
   end  
end

File.open('config/blue_light_special.yml', 'w') do |f2|   
 f2.puts contents
end


rake("db:migrate")

generate :blue_light_special_admin

