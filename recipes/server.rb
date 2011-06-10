#
# Cookbook Name:: noah
# Recipe:: server
#
# Copyright 2010, John E. Vincent <lusis.org+github.com@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
include_recipe "noah::default"

case node.platform
when "debian","ubuntu"
  prereqs = %w{build-essential}
when "redhat","centos","fedora"
  prereqs = %w{gcc gcc-c++}
end

prereqs.each do |prereq|
  p = package prereq do
    action :nothing
  end
  p.run_action(:install)
end

g = gem_package "noah" do
  action :nothing
  version "#{node['noah']['version']}"
end
g.run_action(:install)
Gem.clear_paths
noah_bin = Gem.bin_path('noah','noah',"#{node['noah']['version']}")

remote_file "/tmp/noah-redis.tar.gz" do
  source "http://redis.googlecode.com/files/redis-#{node['noah']['redis_version']}.tar.gz"
  mode "0644"
  #notifies :run, "execute[build_redis]", :immediately
end

user "#{node['noah']['user']}" do
  comment "Noah System Account"
  home "#{node['noah']['home']}"
  shell "/bin/bash"
  system true
  supports :manage_home => true
  action [:create, :modify, :manage]
end

directory "#{node['noah']['logdir']}" do
  owner "noah"
  mode "0750"
end

%w{bin etc data redis}.each do |noah_dir| 
  directory "#{node['noah']['home']}/#{noah_dir}" do
    owner "noah"
    mode "0700"
  end
end

script "build_redis" do
  interpreter "bash"
  user "noah"
  cwd "#{node['noah']['home']}"
  code <<-EOH
  tar -zxf /tmp/noah-redis.tar.gz -C #{node['noah']['home']}/redis/
  cd #{node['noah']['home']}/redis/redis-#{node['noah']['redis_version']}
  make
  EOH
  not_if "test -f #{node['noah']['home']}/redis/redis-#{node['noah']['redis_version']}/src/redis-server"
end

link "#{node['noah']['home']}/redis/current" do
  to "#{node['noah']['home']}/redis/redis-#{node['noah']['redis_version']}"
end

link "#{node['noah']['home']}/bin/redis-server" do
  to "#{node['noah']['home']}/redis/current/src/redis-server"
end

case node.platform
when "ubuntu"
  init_sys = "upstart"
end

template "#{node['noah']['home']}/etc/redis.conf" do
  mode "0640"
  owner "noah"
  action :create
  source "redis.conf.erb"
  variables({:redis_port => node['noah']['redis_port'],
             :log_dir => node['noah']['logdir'],
             :noah_home => node['noah']['home'],
             :init_sys => init_sys,
             :noah_exe => noah_bin})
end

case node.platform
when "ubuntu"
  template "/etc/init/noah-redis.conf" do
    action :create
    source "noah-redis-upstart.erb"
    variables({:noah_user => node['noah']['user'],
              :noah_home => node['noah']['home']})
  end
  template "/etc/init/noah.conf" do
    action :create
    source "noah-upstart.erb"
    variables({:noah_user => node['noah']['user'],
               :noah_port => node['noah']['port'],
               :noah_home => node['noah']['home'],
               :redis_port => node['noah']['redis_port'],
               :log_dir => node['noah']['logdir'],
               :bin_path => noah_bin})
  end
  service "noah-redis" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end

  service "noah" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end
when "redhat","centos","fedora"
  template "/etc/init.d/noah-redis" do
    action :create
    source "noah-redis-init.erb"
  end
  template "/etc/init.d/noah" do
    action :create
    source "noah-init.erb"
  end
end

# register ourself with noah
noah_application "noah"
noah_host "#{node.name}"
noah_service "noah" do
  host "#{node.name}"
end
