if yes?("Do you want file attachments using paperclip?")
  gem 'paperclip', :version => '2.3.0'
  gem 'right_aws'
  
  # Setup s3 for uploading files to amazon s3
  
file "config/s3.yml",
%q{development:
  access_key_id: $access_key_id
  secret_access_key: $secret_access_key
  bucket: $dev_bucket
staging:
  access_key_id: $access_key_id
  secret_access_key: $secret_access_key
  bucket: $staging_bucket
production:
  access_key_id: $access_key_id
  secret_access_key: $secret_access_key
  bucket: $prod_bucket
}

  source_file = File.expand_path(File.dirname(__FILE__)) + "/config/s3.yml"

  $access_key_id = ask("Enter Amazon S3 Access Key ID: ")
  $secret_access_key = ask("Enter Amazon S3 Secret Access Key: ")
  $dev_bucket = ask("Enter Amazon S3 Dev bucket: ")
  $staging_bucket = ask("Enter Amazon S3 Staging bucket: ")
  $prod_bucket = ask("Enter Amazon S3 Production bucket: ")

  File.open(source_file, 'r') do |f1|  
     while line = f1.gets
       if line.include?("$")
         line.gsub!(/\$access_key_id/, dbname) if !line.nil? && !dbname.nil?
         line.gsub!(/\$secret_access_key/, username) if !line.nil? && !username.nil?
         line.gsub!(/\$dev_bucket/, pass) if !line.nil? && !pass.nil?
         line.gsub!(/\$staging_bucket/, dbname_prod) if !line.nil? && !pass.nil?
         line.gsub!(/\$prod_bucket/, dbname_test) if !line.nil? && !pass.nil?
       end
       contents += line  
     end  
  end

  File.open('config/s3.yml', 'w') do |f2|   
   f2.puts contents
  end
