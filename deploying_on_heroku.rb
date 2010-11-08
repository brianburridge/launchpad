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
            if !gem.name.include?('formtastic')
              spec = "#{gem.name} --version '#{gem.version_requirements.to_s}'"
              spec << " --source #{gem.source}" if gem.source
              output << spec
            end
          end
          output << "rails --version 2.3.8"
          output << "formtastic --version '0.9.7' --ignore-dependencies"
          output << "aws-s3"
          f.write output.join("\n")
          puts output.join("\n")
        end
      end
    end
  }

  rake("gems:specify")


  run "heroku create #{app_name}"
  
  run 'curl -L https://github.com/bburridge/launchpad/raw/master/template/script/heroku_deploy > script/heroku_deploy'
  run 'chmod +x script/heroku_deploy'
  
  git :add => "."
  git :commit => "-am 'Prepped for heroku deploy'"

  run "git push heroku master"
  run "heroku addons:add cron:daily"
  run "heroku addons:add exceptional:basic"
  run "heroku addons:add sendgrid:free"
  run "heroku rake db:migrate"
  run "heroku restart"
end