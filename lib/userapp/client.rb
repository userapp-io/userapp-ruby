require 'rest_client'

require File.expand_path('../errors.rb', __FILE__)
require File.expand_path('../hash_utility.rb', __FILE__)
require File.expand_path('../client_options.rb', __FILE__)

module UserApp
	class Client
  		attr_accessor :options

		def initialize(*args)
			@options = self.get_options()

			if args.length == 1 and args[0].class == Hash
				@options.set(args[0])
			else
				if args.length >= 1
					options.app_id = args[0]
				end
				if args.length >= 2
					options.token = args[2]
				end
			end
		end

		def get_options(*args)
			if self.options.nil?
				self.options = ClientOptions.get_global().clone()
			end
			return self.options
		end

		def call(version, service, method, arguments)
			# Build the URL of the API to call
			target_url = 'http' + (!self.options.secure || 's') + '://' + self.options.base_address + '/'
			target_url << 'v' + version.to_s + '/' + service.to_s + '.' + method

			if arguments.nil?
				arguments = {}
			end

			if self.get_options().debug
				self.log("Sending HTTP POST request to '#{target_url}' with app_id '#{self.options.app_id}', token '#{self.options.token}' and arguments '#{arguments.to_json()}'.")
			end

			resource = RestClient::Resource.new(target_url, self.options.app_id, self.options.token)

			resource.post(
				(arguments.nil? ? {} : arguments).to_json(),
				:content_type => :json
			){ |response, request, z_result, &block|
				if self.get_options().debug
					self.log("Recieved HTTP response with code '#{response.code}' and body '#{response.body}'.")
				end

				if response.code != 200 and response.code != 401
					raise Error.new("Recieved HTTP status #{response.code}, expected 200.")
				end

				result = HashUtility.convert_to_object(JSON.parse(response.body))
				is_error_result = result.respond_to?('error_code')

				if self.options.throw_errors and is_error_result
					if result.error_code == 'INVALID_SERVICE'
						raise InvalidServiceError.new("Service '#{service}' does not exist.")
					elsif result.error_code == 'INVALID_METHOD'
						raise InvalidServiceError.new("Method '#{method}' on service '#{service}' does not exist.")
					else
						raise ServiceError.new(result.error_code, result.message)
					end
				end

				if service == 'user'
					if not is_error_result and method == 'login'
						self.options.token = result.token
					elsif method == 'logout'
						self.options.token = nil
					end
				end

				return result
			}
		end

		def log(message)
			options = self.get_options()
			if !options.logger.nil? and options.logger.respond_to?('debug')
				options.logger.debug(message)
			end
		end

		protected :log
	end
end