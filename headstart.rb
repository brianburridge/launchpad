gem "cops", :version => '0.2.0.7', :lib => 'blue_light_special'

generate :blue_light_special

if yes?("Do you want to use Delayed Job?")
  generate :delayed_job
end

rake("db:migrate")

generate :blue_light_special_admin

