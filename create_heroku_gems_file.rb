# This rake task comes from http://madeofcode.com/posts/46-generate-gem-yml-and-gems-for-rails

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