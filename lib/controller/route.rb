module Stupid
	class Route
		def initialize(base)
			@elements = [base]
		end
		
		attr :elements
		
		def /(subpath)
			next_element = @elements.last.paths[subpath]
			raise "No such subpath: #{subpath.inspect}" unless next_element
			@elements << next_element
			self
		end
		
		def empty?; elements.empty?; end
	end
end