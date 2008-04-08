module Stupid
	module Cognite
		attr_accessor :cognate
		attr_accessor :name
		
		def cognate
			return @cognate if @cognate.is_a?(Regexp)
			/^#{Regexp.escape(@cognate.to_s)}$/
		end
	end
end