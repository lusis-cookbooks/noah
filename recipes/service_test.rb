noah_service "httpd" do 
  host "#{node.name}"
end

noah_service "httpd" do
  host "#{node.name}"
  action :delete
end

noah_service "chef-server" do
  host "#{node.name}"
  status "pending"
end
