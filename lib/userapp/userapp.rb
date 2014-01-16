module UserApp
	class Client
		require File.expand_path('../client.rb', __FILE__)
	end
	class ProxyClient
		require File.expand_path('../proxy_client.rb', __FILE__)
	end
	class API < ProxyClient
		require File.expand_path('../api.rb', __FILE__)
	end
end