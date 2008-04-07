namespace :lol, 'lol' do
	before do; end
	
	resource :article, 'article', /(?<id>\d+)/) do
		before do ... end
		after do ... end
		
		index do
			get? { show list }
			post? # will never be true, see 'create'
		end
		
		read do
			get? { show item }
			post? # will never be true, see 'update'
		end
		
		create do
			post? { perform create; redirect }
			get? { render form }
		end
		
		update do
			post? { perform update; redirect }
			get? { render form }
		end
		
		delete do
			post? { actually.do_it }
			get? { render confirmation }
		end
		
		action :regular_action, /lol/, :member do
			# if :member is given:
			# => /article/123/lol
			# if not:
			# => /article/lol
		end
		
		
	end
	
	namespace :test, 'test' do
		index do 	# synonym for action :index, '' do ...
			render whatever
		end
		
		action :something_else, /sumthin/ do
			
		end
	end
end