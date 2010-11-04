


####### NOTE #######
# This is only a sample
######################



# Create .gitignore files
run 'curl -L https://github.com/manuelmeurer/rails-templates/raw/master/gitignore > .gitignore'
run 'touch tmp/.gitignore log/.gitignore vendor/.gitignore'

# Fetch files
run 'mkdir app/views/shared'
%w(
config/database.yml
config/deploy.rb
config/environment.rb
config/app_config.yml
app/helpers/application_helper.rb
).each do |file|
  run "curl -L https://github.com/manuelmeurer/rails-templates/raw/master/#{file} > #{file}"
  gsub_file file, /%project_name%/, project_name
end