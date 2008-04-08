#!/usr/bin/env ruby1.9

require 'lib/stupid'

root do
	design 'test'
	layout 'default'
	
	before do
		puts "before 1"
	end
	
	after { puts "after 1" }
	after { puts "after 1 1" }
	
	controller :lol, 'lol(?<name>.+)?' do
		before { puts "before 2" }
		after { puts "after 2" }
		
		index do
			"HEJSA"
		end
		
		action :test, /^test\/(?<id>\d+)$/ do
			render
		end
		
		controller :nested, 'nested' do
			index do
				render "DAV"
			end
		end
	end
end

root do
	controller :lol do
		action :test2, 'test2' do
			render "TEST2 VIRKEdE!"
		end
	end
end

def print_paths(controller, indent = 0, indent_str = "  ")
	controller.paths.each do |name, sub|
		col1 = (indent_str * indent) + (sub.is_a?(Module) ? sub.to_s : sub.class.to_s)
		col2 = sub.cognate.inspect
		puts(col1.ljust(50) + col2)
		print_paths(sub, indent + 1) unless sub.is_a?(Stupid::Action)
	end
end

puts "PATHS:"
puts "-" * 50
print_paths Stupid::Controller

Stupid::Application.run