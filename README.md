# Ruby library for UserApp


## Getting started

### Finding your App Id and Token

If you don't have a UserApp account, you need to [create one](https://app.userapp.io/#/sign-up/).

* **App Id**: The App Id identifies your app. After you have logged in, you should see your `App Id` instantly. If you're having trouble finding it, [follow this guide](https://help.userapp.io/customer/portal/articles/1322336-how-do-i-find-my-app-id-).

*  **Token**: A token authenticates a user on your app. If you want to create a token for your logged in user, [follow this guide](https://help.userapp.io/customer/portal/articles/1364103-how-do-i-create-an-api-token-). If you want to authenticate using a username/password, you can acquire your token by calling `api.user.login(...)`

### Installing and loading the library

Install using gem:

	$ gem install userapp

Load the library:

	require 'userapp'

### Creating your first client

    api = UserApp::API.new(:app_id => "YOUR APP ID")

#### Additional ways of creating a client

If you want to create a client with additional options the easiest way is to pass the options as shown below.

    api = UserApp::API.new(:debug => true, :throw_errors => true)

## Calling services and methods

This client has no hard-coded API definitions built into it. It merly acts as a proxy which means that you'll never have to update the client once new API methods are released. If you want to call a service/method all you have to do is look at the [API documentation](https://app.userapp.io/#/docs/) and follow the convention below:

    result = api.[service].[method](:[argument] => [value])
    
Please note that you need to mark the method that you want to call with one or several arguments. I.e. `api.user.get()` will NOT call the API `user.get`, instead, it will only instantiate a service called `user.get`. So to call a method on a service you need to pass arguments. If you don't have any arguments, you can just pass `nil`. I.e. the correct call would look like `api.user.get(nil)`.

#### Some examples

The API [`user.login`](https://app.userapp.io/#/docs/user/#login) and its arguments `login` and `password` translates to:

    login_result = api.user.login(:login => "test", password => "test")

The API [`user.invoice.search`](https://app.userapp.io/#/docs/invoice/#search) and its argument `user_id` translates to:

    invoices = api.user.invoice.search(:user_id => "test123")

The API [`property.save`](https://app.userapp.io/#/docs/property/#save) and its arguments `name`, `type` and `default_value` translates to:

    property = api.property.save(:name => "my new property", :type => "boolean", :default_value => true)

The API [`user.logout`](https://app.userapp.io/#/docs/user/#logout) without any arguments translates to:

    api.user.logout(nil)

## Configuration

Options determine the configuration of a client.

### Available options

* **Version** (`version`): Version of the API to call against. Default `1`.
* **App Id** (`app_id`): App to authenticate against. Default `nil`.
* **Token** (`token`): Token to authenticate with. Default `nil`.
* **Debug mode** (`debug`): Log steps performed when sending/recieving data from UserApp. Default: `false`.
* **Secure mode** (`secure`): Call the API using HTTPS. Default: `true`.
* **Base address** (`base_address`): The address to call against. Default: `api.userapp.io`.
* **Throw errors** (`throw_errors`): Whether or not to throw an exception when response is an error. I.e. result `{"error_code":"SOME_ERROR","message":"Some message"}` results in an exception of type `UserApp::ServiceError`.

### Setting options

Options are easiest set in the object constructor. I.e. as shown below:

    api = UserApp::API.new(:debug => true)

Options can also be set after object creation using `api.get_options().[option name]`, as shown below:

	api.get_options().debug = true

## Example code

A more detailed set of examples can be found in /examples.

### Example code (sign up a new user)

    api = UserApp::API.new(:app_id => "YOUR APP-ID")
    api.user.save(:login => "johndoe81", :password => "iwasfirst!111")

### Example code (logging in and updating a user)

    api = UserApp::API.new(:app_id => "YOUR APP-ID")

    api.user.login(:login => "johndoe81", :password => "iwasfirst!111")
    api.user.save(:user_id => "self", :first_name => "John", :last_name => "Doe")

	api.user.logout(nil)

### Example code (finding a specific user)

    api = UserApp::API(:app_id => "YOUR APP-ID", :token => "YOUR TOKEN")

    search_result = api.user.search(:filters => {:query => '*bob*'}, :sort => {:created_at => 'desc'})

    puts search_result.items

## Versioning

If you want to configure the client to call a specific API version you can do it by either setting the `version` option, or by calling the client using the convention `api.v[version number]`. If no version is set it will automatically default to `1`.

### Examples

Since no version has been specified, this call will be made against version `1` (default).

    api.user.login(:login => "test", :password => "test")

Since the version has been explicitly specified using options, the call will be made against version `2`.

	api = UserApp::API.new(:version=2)
    api.user.login(:login => "test", password => "test")

Since the version has been explicitly specified, the call will be made against version `3`.

    api.v3.user.login(login => "test", password => "test")

## Error handling

### Debugging

Sometimes to debug an API error it's important to see what is being sent/recieved from the calls that one make to understand the underlying reason. If you're interested in seeing these logs, you can set the client option `debug` to `true`.

	api = UserApp::API.new(:debug => true)
    api.user.login(:login => "test", :password => "test")

### Catching errors

When the option `throw_errors` is set to `true` (default) the client will automatically throw a `UserApp::ServiceError` exception when a call results in an error. I.e.

	begin
		api.user.save(:user_id => "invalid user id")
	rescue UserApp::ServiceError => error
		if error.error_code == "INVALID_ARGUMENT_USER_ID"
			# Handle specific error
			puts "Invalid user!"
		end
	end

Setting `throw_errors` to `false` is more of a way to tell the client to be silent. This will not throw any service specific exceptions. Though, it might throw a `userapp.UserAppException`.

	result = api.user.save(:user_id => "invalid user id")

	if result.respond_to?('error_code') and result.error_code == "INVALID_ARGUMENT_USER_ID"
    	# Handle specific error
		puts "Invalid user!"
	end

## Special cases

Even though this client works as a proxy and there are no hard-coded API definitions built into it, there are still a few tweaks that are API specific.

#### Calling API `user.login` will automatically set the client token

In other words:

	login_result = api.user.login(:login => "test", :password => "test")

Is exactly the same as:
	
	login_result = api.user.login(:login => "test", :password => "test")
	api.get_options().token = login_result.token

#### Calling API `user.logout` will automatically remove the client token

In other words:

	api.user.logout(nil)

Is exactly the same as:
	
	api.user.logout(nil)
	api.get_options().token = nil

## License

MIT - For more details, see LICENSE.
