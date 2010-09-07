if yes?("Do you want global settings?")
  gem "rails-settings", :lib => 'settings'

  generate(:settings_migration)

  rake("db:migrate")


  file "config/initializers/global_settings.rb", <<-END
  # Place global settings here like
  # if Settings.topics_per_page.nil?
  #   Settings.topics_per_page = 10
  # end
  END

end