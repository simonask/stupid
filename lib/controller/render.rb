require 'erb'

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
			
			# Make public.
			def binding; super; end
			
			def rendered?
				@__rendered
			end
			
			def render_as_string(options = {})
				options = {:template => options} unless options.is_a?(Hash)
				
				if options[:text]
					options[:text]
				else
					render_template(options)
				end
			end
			
			def render(*args)
				response.body = render_as_string(*args)
				@__rendered = true
			end
			
			def render!(*args)
				render(*args)
				raise RenderReturn
			end
			
			def content_for_layout=(content)
				@__content_for_layout = content
			end
			
			def content_for_layout
				@__content_for_layout
			end
			
			protected
			def render_template(options = {})
				options[:template] ||= current_controller.parents.map {|c| c.name }.compact.join('/') + "/#{current_action.name}"
				options[:design] ||= @__design || 'default' if options[:design].nil?	# distinguish between nil and false
				options[:layout] ||= @__layout if options[:layout].nil?
				
				template_path = "#{STUPID_ROOT}/app/designs/#{options[:design]}/#{options[:template]}.html.erb"
				layout_path = options[:layout] ? "#{STUPID_ROOT}/app/designs/#{options[:design]}/#{options[:layout]}.html.erb" : nil
				
				self.content_for_layout = render_template_file(template_path)
				options[:layout] ? render_template_file(layout_path) : self.content_for_layout
			end
			
			def render_template_file(file)
				erb = ERB.new(File.open(file).read)
				erb.result(self.binding)
			end
		end
	end
end

Stupid::Controller.class_eval { extend Stupid::Controller::Layout; include Stupid::Controller::Render }