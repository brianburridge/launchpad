if yes?("Would you like to install Google Analytics?")
  # http://github.com/kennethkalmer/google_analytics
  gem 'rubaidh-google_analytics', :version => '1.1.4', :lib => 'rubaidh/google_analytics', :source => 'http://gems.github.com'

  # Add google analytics in production
  tracker_id = ask("Please enter your google analytics tracker id:")

  contents = ""
  %w(
  config/environments/production.rb
  ).each do |source_file|
    File.open(source_file, 'r') do |f1|  
       while line = f1.gets
         contents += line  
       end  
    end

    File.open(source_file, 'w') do |f2|   
     f2.puts contents
     f2.puts "Rubaidh::GoogleAnalytics.tracker_id = '#{tracker_id}'"
    end
  end

  puts "Google analytics was installed through a gem and added to all views in production."
end