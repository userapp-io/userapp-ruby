require 'logger'
require File.expand_path('../../lib/userapp/userapp.rb', __FILE__)

api = UserApp::API.new(
	:app_id => 'YOUR_APP_ID',
	:token => 'YOUR_TOKEN'
)

begin
	user = api.user.get(:user_id => 'self')[0]
	puts "#{user.email} (#{user.user_id})"
rescue UserApp::Error => error
	puts error
end