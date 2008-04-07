module Stupid
	# This class contains the context of a single request and response.
	# Actions and filters are executed in an instance of this class.
	module ControllerConvenience
		def params
			@__request.params
		end
		
		def request
			@__request
		end
		
		def response
			@__response
		end
		
		def get?
			block_given? && @__request.get? ? yield : @__request.get?
		end
		
		def post?
			block_given? && @__request.post? ? yield : @__request.post?
		end
	end
end