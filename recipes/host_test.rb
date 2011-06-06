noah_host "#{node.name}"

noah_host "#{node.name}" do
  action :delete
end

noah_host "#{node.name}" do
  status "pending"
end
