require 'rack'

module Stupid
	class Application
		public
		def self.call(env)
			path = env['PATH_INFO'].sub(/^\//, '')
			path_params = {}
			action = Stupid::Controller.recognize_path(path) { |param, value|
				path_params[param] = value
			}
			
			# TODO: Put the following in recognize_path
			controller = nil
			if action.is_a?(Class)
				controller = action
				action = controller.actions[:index] || Action.new(controller, :index, '')
			end
			controller ||= action.controller
			
			context = controller.new(env)
			context.current_action = action
			context.metaclass.instance_eval { include Stupid::ControllerConvenience }
			
			context.params.merge!(path_params)
			
			begin
				controller.run_before_filters(context)
				action.call(context)
				context.render unless context.rendered?
				controller.run_after_filters(context)
			rescue Return => ex
				puts "Hard return: #{ex.class}"
			end
			
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