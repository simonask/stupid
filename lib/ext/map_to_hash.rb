module Stupid
	module MapToHash
		def map_to_hash
			map { |e| yield e }.inject({}) { |carry, e| carry.merge! e }
		end
	end
end

Enumerable.class_eval { include Stupid::MapToHash }