module Stupid
	class Controller
		attr_reader :request
		def initialize(request)
			@request = request
		end
		
		class << self
			attr_accessor :name
			attr_accessor :cognate
			attr :paths
			
			def namespace(name, cognate = nil, &block)
				@paths ||= {}
				if @paths[name] && !cognate
					c = @paths[name]
				else
					c = Class.new(Stupid::Controller)
					c.cognate = cognate
					c.name = name
					self.module_eval("#{'::' if self == Stupid::Controller}#{name.capitalize} = c")
					@paths[name] = c
				end
				c.class_eval(&block) if block_given?
				c
			end
			
			def action(name, cognate, &block)
				@paths ||= {}
				@paths[name] = Stupid::Action.new(self, name, cognate, &block)
			end
			
			def index(&block)
				action(:index, '', &block)
			end
			
			def recognize_path(path)
				puts "Calling #{self}.recognize_path(#{path.inspect})"
				path ||= ''
				first_path_element, remaining_path = path.split('/', 2).reject(&:empty?)
				first_path_element ||= ''
				
				@paths.each do |name, action|
					case action.cognate
					when Regexp
						return action if path =~ action.cognate
						return action.recognize_path(remaining_path) if action.cognate.match(first_path_element)
					else
						return action if path == action.cognate
						return action.recognize_path(remaining_path) if first_path_element == action.cognate
					end
				end
				
				raise "Could not recognize path #{path}"
			end
		end
	end
end

def root(&block)
	Stupid::Controller.instance_eval(&block)
end