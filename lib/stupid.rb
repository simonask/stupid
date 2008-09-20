require 'rubygems'
require 'pathname'

STUPID_ROOT = Pathname.new(File.dirname(__FILE__) + "/..").realpath.to_s

STUPID_LOAD_DIRS = ['lib', 'config', 'app']

$LOAD_PATH << File.dirname(__FILE__)

STUPID_LOAD_DIRS.each do |dir|
	Dir.glob("#{STUPID_ROOT}/#{dir}/**/*.rb").each do |file|
		require file
	end
end