#####
#
# These are required to make rvm work properly within crontab
#
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  env "PATH",         ENV["PATH"]
  env "GEM_HOME",     ENV["GEM_HOME"]
  env "MY_RUBY_HOME", ENV["MY_RUBY_HOME"]
  env "GEM_PATH",     ENV["_ORIGINAL_GEM_PATH"] || ENV["BUNDLE_ORIG_GEM_PATH"] || ENV["BUNDLER_ORIG_GEM_PATH"]
end
#
#####