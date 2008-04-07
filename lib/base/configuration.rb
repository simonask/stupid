module Stupid
	class Configuration
		class << self
			attr :handler
			attr :host
			attr :port

			def rack_config
				{:Host => host, :Port => port}
			end
		end
	end
end