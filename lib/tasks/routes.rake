require 'app/api'

desc "display sinatra routes"
task :routes do
  routes = 
    Api.routes.map do |method, routes|
      routes.map { |r| r.first.to_s }.map do |route|
        "#{method.rjust(7, ' ')} #{route}"
      end
    end
  routes.flatten.sort.each do |route|
    puts route
  end
end