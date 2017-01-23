if Rails.env == "development" || Rails.env == "test"
$redis = Redis.new(:host => 'localhost', :port => 6379)
else
 $redis = Redis.new(url: ENV["REDIS_URL"])
end
