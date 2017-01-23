
# if ENV["TMPDIR"] && ENV["TMPDIR"].index("passenger")
# std_out = File.new(RAILS_ROOT + "/log/stdout.log","a")
# std_err = File.new(RAILS_ROOT + "/log/stderr.log","a")
# $stdout.reopen(std_out)
# $stderr.reopen(std_err)
# end


# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
