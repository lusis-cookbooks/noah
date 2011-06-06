include_recipe "noah::default"

noah_host "#{node.name}"

data1 = noah_get("http://localhost:5678/hosts/#{node.name}")

noah_ephemeral "/some/random/path/item1" do
  data "somerandomdata"
end

data2 = noah_get("http://localhost:5678/ephemerals/some/random/path/item1")

file "/tmp/noah_get_test_data1.txt" do
  content "test result data: #{data1}"
  mode "0777"
  backup false
end

file "/tmp/noah_get_test_data2.txt" do
  content "test result data: #{data2}"
  mode "0777"
  backup false
end

noah_ephemeral "/some/random/path/item1" do
  action :delete
end
