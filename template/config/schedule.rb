# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

if File.expand_path(__FILE__) =~ /$app_base_dir_prod/
  set :environment, :production
elsif File.expand_path(__FILE__) =~ /$app_base_dir_staging/
  set :environment, :staging
else
  set :environment, :development
end

set :output, "$output"

if environment.to_s == 'production'
  # clean old backups
  every 1.day, :at => "21:50 pm" do
    command "cd $app_current_dir && RAILS_ENV=#{environment} nice -n 30 /usr/bin/env rake db2s3:backup:clean"
  end

  every 3.hours, :at => [10] do
    command "cd $app_current_dir && RAILS_ENV=#{environment} nice -n 30 /usr/bin/env rake db2s3:backup:full"
  end
end

if environment.to_s == 'staging'
end
