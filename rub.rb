#!/usr/bin/env ruby1.9

require 'lib/stupid'

root do
	index do
		"LOL"
	end
	
	namespace :lol, 'lol' do
		index do
			"HEJSA"
		end
		
		action :test, /^test(?<id>\/\d+)?$/ do
			@lol = "TEST JA"
		end
	end
end

p Stupid::Controller.paths

Stupid::Application.run