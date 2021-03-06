#config/initializers/resque.rb

uri = URI.parse(ENV["REDISCLOUD_URL"] || "redis://localhost:6379/" )

Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }