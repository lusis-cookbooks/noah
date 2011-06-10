# role for search
default['noah']['server_role'] = 'noah_server'

# server options
default['noah']['redis_version'] = '2.2.4'
default['noah']['redis_port'] = 6381
default['noah']['port'] = 5678
default['noah']['user'] = 'noah'
default['noah']['version'] = '0.8.4'
default['noah']['home'] = "/var/lib/noah"
default['noah']['logdir'] = '/var/log/noah'
default['noah']['ruby_vm'] = 'ruby' # unused for now. future support for jruby version

# Client options
default['noah']['client']['timeout'] = 30
default['noah']['client']['on_failure'] = :fail
default['noah']['client']['retry_interval'] = 5
default['noah']['client']['noah_host'] = 'localhost'
default['noah']['client']['noah_port'] = 5678
