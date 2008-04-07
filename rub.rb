#!/usr/bin/env ruby1.9

require 'lib/stupid'

root do
	design 'test'
	
	before do
		puts "before 1"
	end
	
	after { puts "after 1" }
	after { puts "after 1 1" }
	
	def testit
		@hej ||= 0
		@hej += 1
		@hej.to_s
	end
	
	index do
		testit
	end
	
	namespace :lol, 'lol(?<name>.+)?' do
		before { puts "before 2" }
		after { puts "after 2" }
		
		index do
			"HEJSA"
		end
		
		action :test, /^test\/(?<id>\d+)$/ do
			render!("Called with id: #{params[:id]}")
		end
		
		namespace :nested, 'nested' do
			index do
				"DAV"
			end
		end
	end
end

puts LolController.superclass

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