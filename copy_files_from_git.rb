
# Create .gitignore files
run 'curl -L http://github.com/manuelmeurer/rails-templates/raw/master/gitignore > .gitignore'
run 'touch tmp/.gitignore log/.gitignore vendor/.gitignore'

# Fetch files
run 'mkdir app/views/shared'
%w(
config/database.yml
config/deploy.rb
config/environment.rb
config/app_config.yml
app/views/layouts/application.html.haml
app/views/shared/_footer.html.haml
app/views/shared/_header.html.haml
app/views/shared/_menu.html.haml
app/helpers/application_helper.rb
public/javascripts/application.js
).each do |file|
  run "curl -L http://github.com/manuelmeurer/rails-templates/raw/master/#{file} > #{file}"
  gsub_file file, /%project_name%/, project_name
end