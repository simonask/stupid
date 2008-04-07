module Stupid
	class Controller
		def initialize(env)
			@__request = Stupid::Request.new(env)
			@__response = Stupid::Response.new
		end
		
		class << self
			attr_accessor :name
			attr_accessor :cognate
			attr :paths
			
			def cognate
				return @cognate if @cognate.is_a?(Regexp)
				/^#{@cognate.to_s}$/
			end
			
			def namespaces
				(@paths ||= {}).select {|n, p| p.is_a?(Class) }
			end
			
			def actions
				(@paths ||= {}).select {|n, p| p.is_a?(Stupid::Action) }
			end
			
			def namespace(name, cognate = nil, &block)
				@patha ||= {}
				if @paths[name] && !cognate
					c = @paths[name]
				else
					c = Class.new(self)
					c.cognate = cognate
					c.name = name
					self.module_eval("#{'::' if self == Stupid::Controller}#{name.capitalize}Controller = c")
					@paths[name] = c
				end
				c.module_eval(&block) if block_given?
				c
			end
			
			def action(name, cognate, &block)
				@paths ||= {}
				@paths[name] = Stupid::Action.new(self, name, cognate, &block)
			end
			
			def index(&block)
				action(:index, '', &block)
			end
			
			def design(name)
				before { @__design = name }
			end
			
			def layout(name)
				before { @__layout = name }
			end
			
			def recognize_path(path, &block)
				path ||= ''
				# Namespaces and actions have different recognition semantics, so this gets a bit messy.
				# Namespaces may only match a URL path fragment, while actions shall always match the
				# whole path.
				
				return actions[:index] if path.empty?
				
				actions.each do |name, action|
					if m = action.cognate.match(path)
						puts "Action matched: #{action.inspect}"
						m.names.map {|k| k.to_sym }.each {|k| block.call(k, m[k]) } if block_given?
						return action
					end
				end
				
				first_path_element, remaining_path = path.split('/', 2).reject(&:empty?)
				first_path_element ||= ''
				
				namespaces.each do |name, namespace|
					if m = namespace.cognate.match(first_path_element)
						puts "Namespace matched: #{namespace.inspect}"
						m.names.map {|k| k.to_sym }.each {|k| block.call(k, m[k]) } if block_given?
						return namespace.recognize_path(remaining_path, &block)
					end
				end
				
				raise "Could not recognize path #{path}"
			end
			
			def old_recognize_path(path)
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