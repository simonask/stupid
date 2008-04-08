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
			
			def render(options = {})
				options = {:template => options} if options.is_a?(String)
				
				design = @__design || 'default'
				layout = @__layout
				auto_template = current_controller.parents.map {|c| c.name }.compact.join('/')
				
				options = {
					:template => auto_template,
					:design => design,
					:layout => layout,
				}.merge(options)
				
				template_path = "#{STUPID_ROOT}/app/designs/#{options[:design]}/#{options[:template]}"
				layout_path = layout ? "#{STUPID_ROOT}/app/designs/#{options[:design]}/#{options[:layout]}" : nil
				
				response.body = "rendering #{template_path} with layout #{layout_path}"
			end
			
			def render!(*args)
				render(*args)
				raise RenderReturn
			end
		end
	end
end

Stupid::Controller.class_eval { extend Stupid::Controller::Layout; include Stupid::Controller::Render }