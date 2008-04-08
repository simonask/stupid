require File.join(File.dirname(__FILE__), 'cognite')

module Stupid
	class Action
		include Stupid::Cognite
		attr :controller
		attr :action
		
		def initialize(klass, name, cognate, &block)
			self.name = name
			self.cognate = cognate
			@controller = klass
			@action = block
		end
		
		def call(context)
			context.instance_eval(&@action)
		end
	end
end