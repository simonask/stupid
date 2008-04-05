module Stupid
	class Controller
		class << self
			attr_accessor :paths
			
			def /(subpath)
				Route.new(self, subpath)
			end
			
			def inherited(subclass)
				(@paths || []).each do |path|
					Route.register_class(subclass, path)
				end
				puts "Class inherited: #{subclass} with paths: #{@paths}"
			end
			
			def path(name, p, &block)
				Route.register_path(self, name, p)
				obj = BasicObject.new
				obj.instance_eval(&block)
				@subpaths ||= []
				@subpaths[name] = obj
			end
			
			def handle_route(route)
				raise "bleh?" unless route.elements.first == self
				@instance ||= self.new
				
			end
		end
	end
end

def P(*paths)
	c = Class.new(Stupid::Controller)
	c.paths = paths
	c
end