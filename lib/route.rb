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
	end
end