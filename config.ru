# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require "rubygems"
require "bundler"
Bundler.require

# Local config
require "find"
Find.find("lib") { |f|
  require f unless f.match(/\/\..+$/) || File.directory?(f)
}

# Load app
require "humans_app"
run HumansApp
