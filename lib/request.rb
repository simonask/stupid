module Stupid
	class Request
		attr :headers
		def initialize(env)
			@headers = env
		end
		
		def path
			@headers["PATH_INFO"]
		end
		
		def request_method
			@request_method ||= @headers["REQUEST_METHOD"].downcase.to_sym
		end
		
		def uri
			@headers["REQUEST_URI"]
		end
		
		def remote_host
			@headers["REMOTE_HOST"]
		end
		
		def server_name
			@headers["SERVER_NAME"]
		end
		
		def server_port
			@headers["SERVER_PORT"].to_i
		end
		
		def query_string
			@headers["QUERY_STRING"]
		end
		
		def user_agent
			@headers["HTTP_USER_AGENT"]
		end
		
		def params
			@params ||= query_string.split('&').map_to_hash { |e|
				key, value = e.split('=', 2)
				{key => value}
			}.with_indifferent_access
		end
		
		def get?
			request_method == :get
		end
		
		def post?
			request_method == :post
		end
	end
end