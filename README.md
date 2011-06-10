# Noah cookbook
================
This cookbook has been tested on the following platforms (for installing the server)

* Natty 32-bit Rubygems install
* Natty 64-bit Rubygems install
* Lucid 32-bit Vagrant
* Lucid 64-bit Vagrant

Right now, only the ubuntu-related stuff is really stubbed out. Init script templates for redhat and non-upstart debian need to be written.
The init scripts should be resilient enough to get populated with the proper path to the noah binscript. It uses `Gem.bin_path` to get it.
The main reason for this is working around system rubies that do stupid crap like dump binaries in `/var/lib/gems/bin` or something.

If you want to test it, the recipe you want is `noah::server`.

This will install Noah from rubygems, compile redis from source into a self-contained directory and then create two startup scripts - noah-redis and noah.

# Recipes

- `noah::default`: provides the Noah LWRP
- `noah::server`: Installs a Noah server
- `noah::client`: For use with Chef Server. Searches for local Noah server and sets default attributes for clients.
- `noah::register`: Registers the current node in Noah both as a `Host` primitive and an `Ephemeral` record under `/chef/node_name`

## Client usage
If you are running with a Chef server, the best option is to use `noah::client` as the first recipe in your role/run\_list and `noah::register` as the last recipe in your role/run\_list

## Search Attribute
A single attribute is exposed for use in search. By assigning a node with this role, clients can find the local Noah server.

- `server_role`

## Server Attributes
You can see the exposed attributes but the key server ones are:

- `redis_version`
- `redis_port`
- `noah_port`

If you're okay with it, the default install dir for everything is /var/lib/noah.

## Client Attributes
Client attributes are a bit different in how they operate based on the resource you're using

- `timeout`
- `on_failure`
- `retry_interval`
- `noah_host`
- `noah_port`

You can read more about what happens with each specific resource below.

## Just the LWRP
If you just want to use the LWRP, all you need to do is add `noah::default` as a dependency to your cookbook and include the recipe. This also provides additional methods in your cookbook:

- `noah_get`
- `noah_search`

# Resources
The following resources are exposed by the LWRP:

- `noah_application` - no custom parameters
- `noah_service` - `host`, `status`
- `noah_ephemeral` - `data` 
- `noah_configuration` - `data`, `format`
- `noah_host` - `status`
- `noah_block`\* - `data`, `on_failure`

Each of these resource take a common set of parameters in the DSL:

- `noah_host`
- `noah_port`
- `retry_interval`
- `timeout`

These are pulled from node attributes unless otherwise specified. With the exception of `noah_block`, `timeout` and `retry_interval` only take effect when the Noah server is unreachable. Errors are thrown if the connection to the Noah server times out or Noah returns anything other than a `200` response. Each resource also has a specific set of parameters related to that resource which match up with the Noah attributes

Additionally, two new methods are available that you can call to lookup information:

- `noah_get`
- `noah_search`

`noah_get` takes a full URL to a Noah resource and converts the JSON result to a ruby hash. The response is unaltered beyond that. If the response cannot be converted, it assumed to be an ephemeral and served "raw".
`noah_search` takes a Noah object type and an string. This is not a "real" search. It simply grabs all objects of the given type and looks for keys that contain the provided string. It is not a replacement for Chef's built in search.

## Blocking
`noah_block` is a special resource best used for coordinating interaction between client bootstraps. Imaging a use case where a load balancer needs to know all of the application servers. Until those application servers have bootstrapped fully, they will not be available as search results. Using Ephemerals (for now), `noah_block` allows you to "block" a portion of a chef-client run until some data is available in Noah. Using the `on_failure` attribute, you can either `:pass`, `:retry` or `:fail` based on the results of Noah query.

Take the following example:

	noah_block "wait for dbmaster" do
	  path            "http://localhost:5678/ephemerals/foo"
	  timeout         600
	  data            "someval1"
	  retry_interval  5
	  on_failure      :pass
	end

In this case, the client run will poll every 5 seconds for 600 seconds until it gets "someval" as a response from "http://localhost:5678/ephemerals/foo". If Noah is unreachable or it does not get the response it expects, it will simply continue with the rest of the recipe. An `on_failure` value of `:fail` will error out immediately. An `on_failure` value of `:retry` will continue retrying even if Noah is unreachable until the timeout value.

The exception to a `:pass` is when the data doesn't match. It makes no sense to allow you to continue if there is data there but is not correct. Imagine the scenario where you need the value of the path to be "go" but it's "stop". If we were to pass from there, we might perform something that should not performed.

**All `noah_block` resource will retry, the `on_failure` guard is to determine how to respond to an error**

# Test Suite
There's a small "test suite" of recipes included. If you include `noah::test` in your run\_list, it will perform a series of tests that ensure some basic functionality. The last test to run is for `noah_block` and it's designed to test proper failure. This test suite will fail intentionally at the end if everything is working properly.

# TODO
- DRY the code out.
- ??????????
