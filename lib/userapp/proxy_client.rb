require 'json'

require File.expand_path('../client.rb', __FILE__)
require File.expand_path('../errors.rb', __FILE__)

module UserApp
	class ProxyClient
		attr_accessor :client
		attr_accessor :services
		attr_accessor :service_name
		attr_accessor :service_version

		def initialize(*args)
			@services = Hash.new()
			if (args.length == 2 or args.length == 3) and args[0].is_a?(Client)
				@client = args[0]
				@service_name = args[1]
				@service_version = args.length == 2 ? 1 : args[2]
			else
				self.service_version = 1
				@client = Client.new(*args)
			end
		end

		def get_options()
			return self.client.get_options()
		end

		def method_missing(method_id, *args)
			if args.length > 0
				if self.service_name.nil?
					raise UserAppError.new("Unable to call method on base service.")
				end

				self.client.call(self.service_version, self.service_name, method_id.to_s(), args[0])
			else
				target_service = nil
				target_version = nil

				if self.services[method_id]
					return self.services[method_id]
				end

				if self.service_name.nil? and method_id.length >= 2 and method_id[0] == 'v' and method_id[1, method_id.length-1].match(/\A[0-9]+\Z/)
					target_version = method_id[1].to_i
				end

				if target_version.nil?
					target_version = self.service_version
					if !self.service_name.nil?
						target_service = self.service_name.to_s + '.' + method_id.to_s
					else
						target_service = method_id.to_s
					end
				end

				proxy = ProxyClient.new(self.client, target_service, target_version)
				self.services[method_id] = proxy

				return proxy
			end
		end
	end
end