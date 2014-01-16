require 'logger'
require 'userapp'
#require File.expand_path('../../lib/userapp/userapp.rb', __FILE__)

api = UserApp::API.new(
	:app_id => '52b8ab9533604',
	:token => 'fc9fJ1mrT4_1JVOZDu80Hng'
)

begin
	user_result = api.user.get(:user_id => 'sellf')
	if user_result.respond_to?('error_code')
		puts 'Me gots errors!'
		puts user_result
	else
		puts user_result[0].first_name
	end
rescue UserApp::Error => error
	puts 'Exception rescued'
	puts error
end