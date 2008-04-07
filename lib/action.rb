module Stupid
	class Action
		attr_accessor :cognate
		attr :controller
		attr :action
		attr :name
		def initialize(klass, name, cognate, &block)
			@cognate = cognate
			@controller = klass
			@action = block
			@name = name
		end
		
		def call(context)
			context.instance_eval(&@action)
		end
		
		def recognize_path(path)
			# TODO: sub-actions?
			self
		end
	end
end