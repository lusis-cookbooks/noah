maintainer        "John E. Vincent"
maintainer_email  "lusis.org+github.com@gmail.com"
license           "Apache 2.0"
description       "Installs Noah"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.7"

recipe "noah::server", "Installs the Noah server with self-contained Redis"
recipe "noah::client", "Installs the Noah Watcher callback daemon"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end
