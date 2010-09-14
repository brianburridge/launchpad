gem "headstart", :version => '0.2.0'
gem 'formtastic', :version => '0.9.7'
gem 'will_paginate',, :version => '2.2.2'

  
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

