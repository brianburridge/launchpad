if yes?("Do you want to install ZenDesk?")

  zendesk_url = ask("What is your ZenDesk url?")
  source_file = File.expand_path(File.dirname(__FILE__)) + "/app/views/layouts/application.html.erb"

zendesk_code = <<-END
<script type="text/javascript" src="//assets0.zendesk.com/external/zenbox/overlay.js"></script>
<link rel="stylesheet" type="text/css" href="//assets0.zendesk.com/external/zenbox/overlay.css" />
<script type="text/javascript">
  if (typeof(Zenbox) !== "undefined") {
    Zenbox.init({
      url:       "<%= zendesk_url %>",
      tab_id:    "ask_us",
      tab_color: "black",
      title:     "<%= Settingt.title %>",
      text:      "How may we help you? Please fill in details below, and we'll get back to you as soon as possible.",
      tag:       "dropbox"
    });
  }
</script>
END
  
else
  zendesk_code = ""
end



contents = ""
File.open(source_file, 'r') do |f1|  
   while line = f1.gets
     if line.include?("$")
       line.gsub!(/\$zendesk/, zendesk_code) if !line.nil?
     end
     contents += line  
   end  
end

File.open('app/views/layouts/application.html.erb', 'w') do |f2|   
 f2.puts contents
end