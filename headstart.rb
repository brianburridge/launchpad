gem "cops"

generate :blue_light_special

if yes?("Do you want to use Delayed Job?")
  generate :delayed_job
end

rake db:migrate

generate :blue_light_special_admin

