module Stupid
	class Response
		attr_accessor :body
		attr :headers
		attr_accessor :status
		
		def initialize
			@headers = {"Content-Type" => "text/html; charset=utf-8"}
			@status = 200
		end
	end
end