module Stupid
	class Action
		attr_accessor :cognate
		attr :controller
		attr :action
		attr :name
		
		def cognate
			return @cognate if @cognate.is_a?(Regexp)
			/^#{@cognate.to_s}$/
		end
		
		def initialize(klass, name, cognate, &block)
			@cognate = cognate
			@controller = klass
			@action = block
			@name = name
		end
		
		def call(context)
			context.instance_eval(&@action)
		end
	end
end