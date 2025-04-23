ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# ✅ Fix logger load issue
require "logger"

# ❌ Temporarily disable bootsnap — causes issues with Logger in 7.0.8 and Ruby 3.1+
# require "bootsnap/setup"
