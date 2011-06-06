noah_ephemeral "/rundeck-demo/noah_server" 

noah_ephemeral "/rundeck-demo/noah_server" do
  action :delete
end

noah_ephemeral "rundeck-demo/noah_server"

noah_ephemeral "rundeck-demo/noah_server" do
  action :delete
end

noah_ephemeral "/rundeck-demo/noah_server" do
  data "#{node.name}"
end
