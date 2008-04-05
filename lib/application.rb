require 'lib/compat'
require 'lib/configuration'

module Stupid
	class Application
		public
		def self.call(env)
			path = env['PATH_INFO']
			route = Route.recognize(path)
			klass = route.elements.first
			body = klass.handle_route(route)
			[200, {"Content-Type" => "text/html"}, body]
		end
		
		def self.configure(&block)
			Stupid::Configuration.instance_eval(&block)
		end
		
		def self.run
			Stupid::Configuration.handler.run(self, Stupid::Configuration.rack_config)
		end
	end
end