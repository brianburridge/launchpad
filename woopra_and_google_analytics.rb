google_analytics = ask("If you would like to track stats via Google Analytics enter your tracking code?")

woopra = yes?("Do you want to use woopra?")

if woopra || google_analytics.present?
  contents = ""
  File.open("config/initializers/global_settings.rb", 'r') do |f1|  
     while line = f1.gets
       contents += line  
     end  
  end

  File.open("config/initializers/global_settings.rb", 'w') do |f2|   
   f2.puts contents
   f2.puts "if  ActiveRecord::Base.connection.tables.include?('settings')"
   f2.puts "Settings.google_analytics = '#{google_analytics}'" if google_analytics.present?
   if woopra
     f2.puts "Settings.woopra = true"
   else
     f2.puts "Settings.woopra = false"
   end
   f2.puts "end"
  end
end