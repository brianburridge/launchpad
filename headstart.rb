gem "cops", :version => '0.2.0.7', :lib => 'blue_light_special'
gem 'formtastic'
gem 'will_paginate'
# must use paperclip 2.3.0 at this point due to conflict between aws-s3 (needed by paperclip 2.3.1 and right_aws needed by backup_fu plugin)
gem 'paperclip', :version => '2.3.0'
gem 'right_aws'
  
generate :blue_light_special

if yes?("Do you want to use Delayed Job?")
  generate :delayed_job
end

rake("db:migrate")

generate :blue_light_special_admin

