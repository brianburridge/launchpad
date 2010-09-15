if yes?("Do you want file attachments using paperclip?")
  gem 'paperclip', :version => '2.3.0'
  gem 'right_aws', :version => '1.10.0'
  
  # Setup s3 for uploading files to amazon s3
  


  #source_file = File.expand_path(File.dirname(__FILE__)) + "/config/s3.yml"

  access_key_id = ask("Enter Amazon S3 Access Key ID: ")
  secret_access_key = ask("Enter Amazon S3 Secret Access Key: ")
  dev_bucket = ask("Enter Amazon S3 Dev bucket: ")
  staging_bucket = ask("Enter Amazon S3 Staging bucket: ")
  prod_bucket = ask("Enter Amazon S3 Production bucket: ")

file "config/s3.yml",<<-END
development:
  access_key_id: #{access_key_id}
  secret_access_key: #{secret_access_key}
  bucket: #{dev_bucket}
staging:
  access_key_id: #{access_key_id}
  secret_access_key: #{secret_access_key}
  bucket: #{staging_bucket}
production:
  access_key_id: #{access_key_id}
  secret_access_key: #{secret_access_key}
  bucket: #{prod_bucket}
END

end