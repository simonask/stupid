Stupid::Application.configure do
	@handler = Rack::Handler::WEBrick
	@host = "localhost"
	@port = 3000
end