puts "Running jammit to prep files before initial checkin"
run "jammit"

git :init

file ".gitignore", <<-END
cached/*
log/*.log
log/*.pid
tmp/**/*
shared/**/*
tmp/restart.txt
.DS_Store
*~
db/schema.rb
END

git :add => "."
git :commit => "-am 'initial commit'"

