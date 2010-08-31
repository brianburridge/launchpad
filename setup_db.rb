current_app_name = Dir.pwd.split("/").last
dbname_entry = ask("Database name [#{current_app_name[0..64]}_development]: ")
while dbname_entry.size > (64-12)
  puts "*Name of db is too long (#{dbname_entry.size}. The limit is 64.)"
  dbname_entry = ask("Database name [#{current_app_name[0..64]}_development]: ")
end

if dbname_entry.nil? || dbname_entry.size == 0
  dbname = current_app_name[0..64]
  dbname = "#{dbname}_development" 
else
  dbname = dbname_entry
end

# Name dbs of other environment
dbname_prod = "#{dbname}_production"
dbname_test = "#{dbname}_test"

# Ask for username for db to be created, defaulting to app name plus _dev
username = ask("Username [#{current_app_name}_dev]: ")
username = "#{current_app_name}_dev" if username.nil? || username.size == 0

# Ask for password for db to be created, defaulting to username
pass = ask("Password [#{username}]: ")
pass = username if pass.nil? || pass.size == 0

contents = ""

file "config/database.yml",
%q{development:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: $dbname
  pool: 5
  username: $username
  password: $password

test:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: $dbname_test
  pool: 5
  username: 
  password: 
  socket: /tmp/mysql.sock

production:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: $dbname_prod
  pool: 5
  username: 
  password: 
  socket: /tmp/mysql.sock
}

source_file = File.expand_path(File.dirname(__FILE__)) + "/config/database.yml"

File.open(source_file, 'r') do |f1|  
   while line = f1.gets
     if line.include?("$")
       line.gsub!(/\$dbname/, dbname) if !line.nil? && !dbname.nil?
       line.gsub!(/\$username/, username) if !line.nil? && !username.nil?
       line.gsub!(/\$password/, pass) if !line.nil? && !pass.nil?
       line.gsub!(/\$dbname_prod/, dbname_prod) if !line.nil? && !pass.nil?
       line.gsub!(/\$dbname_test/, dbname_test) if !line.nil? && !pass.nil?
     end
     contents += line  
   end  
end

File.open('config/database.yml', 'w') do |f2|   
 f2.puts contents
end

mysql_command = "mysql -u root -p -e \"create database #{dbname}; grant all on #{dbname}.* to #{username}@'localhost' identified by '#{pass}'\";"
puts "Executing #{mysql_command}"
system mysql_command