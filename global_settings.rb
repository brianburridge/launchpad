current_app_name = Dir.pwd.split("/").last

if yes?("Do you want global settings?")
  gem "rails-settings", :lib => 'settings'

  generate(:settings_migration)

  rake("db:migrate")

title = ask("Web app title? [#{current_app_name}]")
title = current_app_name if title.blank?

description = ask("Web app description (used on home page)?")

file "config/initializers/global_settings.rb", <<-END
 # Place global settings here like
 Settings.page_limit = 10
 Settings.title = "#{title}"
 Settings.description = "#{description}"
END

end