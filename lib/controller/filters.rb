module Stupid
	class Controller
		module Filters
			def before_filters
				@before_filters ||= []
			end
			
			def after_filters
				@after_filters ||= []
			end
			
			def before(&block)
				@before_filters ||= []
				@before_filters << block
			end
			
			def after(&block)
				@after_filters ||= []
				@after_filters << block
			end
			
			def run_before_filters(context)
				all_filters = controller_ancestors.map { |a| a.before_filters }.flatten
				all_filters.each do |filter|
					context.instance_eval(&filter)
				end
			end
			
			def run_after_filters(context)
				all_filters = controller_ancestors.reverse.map { |a| a.after_filters }.flatten
				all_filters.each do |filter|
					context.instance_eval(&filter)
				end
			end
			
			protected
			def controller_ancestors
				ret = []
				cur = self
				until cur == Object
					ret.unshift(cur)
					cur = cur.superclass
				end
				ret
			end
		end
	end
end

Stupid::Controller.class_eval { extend Stupid::Controller::Filters }