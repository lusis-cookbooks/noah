maintainer        "John E. Vincent"
maintainer_email  "lusis.org+github.com@gmail.com"
license           "Apache 2.0"
description       "Installs Noah"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.8.2"

recipe "noah::default", "Provides the Noah LWRP"
recipe "noah::server", "Installs the Noah server with self-contained Redis"
recipe "noah::client", "Uses search to find local Noah server for client settings"
recipe "noah::register", "Provides for self-registration of node in Noah"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

attribute "noah",
  :display_name => "Noah Server Hash",
  :description => "Hash of Noah Server Attributes",
  :type => "hash"

attribute "noah/client",
  :display_name => "Noah Client Hash",
  :description => "Hash of Noah Client Attributes",
  :type => "hash"

attribute "noah/server_role",
  :display_name => "Server Role",
  :description => "Role to use in search-based autodiscovery of a Noah server",
  :default => "noah_server"

attribute "noah/redis_version",
  :display_name => "Redis Version",
  :description => "Version of Redis to use with Noah",
  :default => "2.2.4"

attribute "noah/redis_port",
  :display_name => "Redis Port",
  :description => "Port number for Redis to bind",
  :default => "6381"

attribute "noah/port",
  :display_name => "Port",
  :description => "Port number for Noah to bind",
  :default => "5678"

attribute "noah/user",
  :display_name => "User",
  :description => "System account to run Noah",
  :default => "noah"

attribute "noah/version",
  :display_name => "Noah Version",
  :description => "Version of Noah to install",
  :default => "0.8.4"

attribute "noah/home",
  :display_name => "Noah Home Directory",
  :description => "Directory to install Noah. Redis data is stored here.",
  :default => "/var/lib/noah"

attribute "noah/logdir",
  :display_name => "Noah Log Directory",
  :description => "Directory to use for Noah Logs",
  :default => "/var/log/noah"

attribute "noah/client/timeout",
  :display_name => "Noah Client Timeout",
  :description => "Time to wait in connecting to Noah (in seconds)",
  :default => "30"

attribute "noah/client/on_failure",
  :display_name => "Noah Client Failure Response",
  :description => "Client response to failure in connecting to Noah",
  :default => ":fail"

attribute "noah/client/retry_interval",
  :display_name => "Noah Client Retry Interval",
  :description => "Number of times to retry connection before failing",
  :default => "5"

attribute "noah/client/noah_host",
  :display_name => "Noah Client Default Server",
  :description => "Host to use as the Noah Server",
  :default => "localhost"

attribute "noah/client/noah_port",
  :display_name => "Noah Client Default Server Port",
  :description => "Port to use for the default Noah Server",
  :default => "5678"
