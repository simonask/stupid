module Stupid
	class HashWithIndifferentAccess < Hash
		def initialize(constructor = nil)
			super(nil)	# disable 'default' feature, since we rely on the default being nil
			merge!(constructor) if constructor.is_a?(Hash)
			self.default = nil
		end
		
		def [](key)
			super(key) || (key.is_a?(Symbol) && super(key.to_s)) || (key.is_a?(String) && super(key.to_sym))
		end
		
		def with_indifferent_access; self; end
	end
end

class Hash
	def with_indifferent_access
		Stupid::HashWithIndifferentAccess.new(self)
	end
end