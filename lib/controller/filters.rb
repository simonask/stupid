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
				all_filters = parents.map { |a| a.before_filters }.flatten
				all_filters.each do |filter|
					context.instance_eval(&filter)
				end
			end
			
			def run_after_filters(context)
				all_filters = parents.reverse.map { |a| a.after_filters }.flatten
				all_filters.each do |filter|
					context.instance_eval(&filter)
				end
			end
		end
	end
end

Stupid::Controller.class_eval { extend Stupid::Controller::Filters }