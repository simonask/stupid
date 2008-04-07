module Stupid
	class Controller
		module Layout
			def design(name)
				before { @__design = name }
			end
			
			def layout(name)
				before { @__layout = name }
			end
		end
		
		module Render
			class RenderReturn < Return; end
			
			def render(text)
				response.body = text
			end
			
			def render!(*args)
				render(*args)
				raise RenderReturn
			end
		end
	end
end

Stupid::Controller.class_eval { extend Stupid::Controller::Layout; include Stupid::Controller::Render }