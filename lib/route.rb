module Stupid
	class Route
		def initialize(*elements)
			@elements = elements
		end
		
		attr :elements
		
		def /(subpath)
			@elements << subpath if subpath
			self
		end
		
		def empty?; elements.empty?; end
		
		class << self
			attr :root
			
			def register_class(klass, path)
				@root ||= Element.new(nil, nil)
				@root.children << Element.new(path, klass)
			end
			
			def register_path(klass, name, path)
				e = @root.find_element(klass)
				e.children << Element.new(path, name)
			end
			
			def recognize(path)
				path_elements = path.split('/').reject(&:empty?)
				path_elements = [''] if path_elements.empty?
				route = @root.expand_route(Route.new, path_elements)
				raise "Unrecognized route: #{path}" unless route && !route.empty?
				route
			end
		end
		
		class Element
			attr_accessor :element
			attr_accessor :cognate
			attr_accessor :children
			
			def initialize(cognate, element)
				@cognate = cognate
				@element = element
				@children = []
			end
			
			def find_element(e)
				return self if @element == e
				return @children.detect { |c| c.find_element(e) }
			end
			
			def expand_route(base, path_elements)
				return nil if base.empty? and path_elements.empty?
				
				if @element.nil?
					# This is the root element, so just skip ahead
					return @children.map { |child| child.expand_route(base, path_elements) }.compact.first
				end
				
				pe = path_elements.shift
				puts "Looking at path element: #{pe.inspect} with cognate #{@cognate.inspect}"
				if (@cognate.is_a?(Regexp) && pe =~ @cognate) || pe == @cognate
					new_base = base / element
					return new_base if path_elements.empty?
					return @children.map {|child| child.expand_route(new_base, path_elements) }.compact.first
				else
					return nil
				end
			end
		end
	end
end