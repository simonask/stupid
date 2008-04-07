require 'lib/compat'
require 'lib/configuration'

module Stupid
	class Application
		public
		def self.call(env)
			path = env['PATH_INFO'].sub(/^\//, '')
			action = Stupid::Controller.recognize_path(path)
			# TODO: Put the following in recognize_path
			if action.is_a?(Class) && action.ancestors.include?(Stupid::Controller)
				controller = action
				action = controller.paths[:index] || Action.new(controller, :index, '')
			end
			context = Stupid::Context.new(env)
			context.response.body = action.call(context)
			p context
			[context.response.status, context.response.headers, context.response.body]
		end
		
		def self.configure(&block)
			Stupid::Configuration.instance_eval(&block)
		end
		
		def self.run
			Stupid::Configuration.handler.run(self, Stupid::Configuration.rack_config)
		end
	end
end