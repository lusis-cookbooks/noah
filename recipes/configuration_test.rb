noah_configuration "noah_server" do
  data        "http://localhost:5678"
end

noah_configuration "noah_server" do
  action :delete
end

noah_configuration "my_json_config" do
  format "json"
  data '{"somevar":"someval","foo_objects":["foo1","foo2","foo3"]}'
end
