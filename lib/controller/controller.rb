require File.join(File.dirname(__FILE__), 'cognite')

module Stupid
	class Controller
		attr_accessor :current_action
		
		def initialize(env)
			@__request = Stupid::Request.new(env)
			@__response = Stupid::Response.new
		end
		
		def current_controller
			current_action.controller
		end
		
		def /(path_element)
			self.class / path_element
		end
		
		def parent
			self.class.parent
		end
		
		class << self
			include Stupid::Cognite
			attr :paths
			
			def paths
				@paths ||= {}
			end
			
			def controllers
				paths.select {|n, p| p.is_a?(Class) }
			end
			
			def actions
				paths.select {|n, p| p.is_a?(Stupid::Action) }
			end
			
			def controller(name, cognate = nil, &block)
				@paths ||= {}
				c = nil
				if @paths[name] && !cognate
					c = @paths[name]
				else
					@paths[name] ||= Class.new(self)
					c = @paths[name]
					c.cognate = cognate
					c.name = name
					
					# Assign the new class to a constant. This name is never used internally, but
					# helps tremendously in debugging (because Ruby givea a class a name when
					# it is assigned to a constant).
					self.module_eval("#{'::' if self == Stupid::Controller}#{name.capitalize}Controller = c")
				end
				c.module_eval(&block) if block_given?
				c
			end
			
			def action(name, cognate = nil, &block)
				@paths ||= {}
				if block_given? && !cognate.nil?
					warn "WARNING: Overriding action #{self}/#{name}" if @paths[name]
					@paths[name] = Stupid::Action.new(self, name, cognate, &block)
				end
				@paths[name]
			end
			
			def index(&block)
				action(:index, '', &block)
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
				
				controllers.each do |name, controller|
					if m = controller.cognate.match(first_path_element)
						puts "Namespace matched: #{controller.inspect}"
						m.names.map {|k| k.to_sym }.each {|k| block.call(k, m[k]) } if block_given?
						return controller.recognize_path(remaining_path, &block)
					end
				end
				
				raise "Could not recognize path #{path}"
			end
			
			def parents
				ret = []
				cur = self
				until cur == Object
					ret.unshift(cur)
					cur = cur.superclass
				end
				ret
			end
			
			def /(path_element)
				Route.new(self) / path_element
			end
		end
	end
end

def root(&block)
	Stupid::Controller.instance_eval(&block) if block_given?
	Stupid::Controller
end