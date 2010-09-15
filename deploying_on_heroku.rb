if yes?("Do you want to deploy to heroku?")
  # This rake task comes from http://madeofcode.com/posts/46-generate-gem-yml-and-gems-for-rails
  app_name = ask("Heroku app name?")

  file "lib/tasks/gems_specify.rake",
  %q{namespace :gems do
      desc "Spit out gems.yml and .gems in root of app (for Heroku + EY etc.)"
      task :specify => :environment do
        gems = Rails.configuration.gems
    
        # output gems.yml
        yaml = File.join(RAILS_ROOT, "gems.yml")
        File.open(yaml, "w") do |f|
          output = []
          gems.each do |gem|
            spec = { "name" => gem.name, "version" => gem.version_requirements.to_s }
            spec["install_options"] = "--source #{gem.source}" if gem.source
            output << spec
          end
          output << "- name: rails"
          output << "  version: = 2.3.8"
          f.write output.to_yaml
          puts output.to_yaml
        end
    
        # output .gems
        dot_gems = File.join(RAILS_ROOT, ".gems")
        File.open(dot_gems, "w") do |f|
          output = []
          gems.each do |gem|
            spec = "#{gem.name} --version '#{gem.version_requirements.to_s}'"
            spec << " --source #{gem.source}" if gem.source
            output << spec
          end
          output << "rails --version 2.3.8"
          f.write output.join("\n")
          puts output.join("\n")
        end
      end
    end
  }

  rake("gems:specify")

  # Add email url for sengrid on heroku
  contents = ""
  %w(
  config/environments/development.rb
  config/environments/production.rb
  ).each do |source_file|
    File.open(source_file, 'r') do |f1|  
       while line = f1.gets
         contents += line  
       end  
    end

    File.open(source_file, 'w') do |f2|   
     f2.puts contents
     f2.puts "config.action_mailer.default_url_options = { :host => 'localhost' }" if source_file.include?('development')
     f2.puts "config.action_mailer.default_url_options = { :host => '#{app_name}.heroku.com' }" if source_file.include?('production')
    end
  end


  run "heroku create #{app_name}"

  git :add => "."
  git :commit => "-am 'Prepped for heroku deploy'"

  run "git push heroku master"
  run "heroku rake db:migrate"
  run "heroku addons:add cron:daily"
  run "heroku addons:add exceptional:basic"
  run "heroku addons:add sendgrid:free"
end