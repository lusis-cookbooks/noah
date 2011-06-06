noah_block "Block wait test" do
  path            "http://localhost:5678/ephemerals/eventually-here"
  timeout         600
  data            "someval1"
  retry_interval  5
  on_failure      :retry
end

noah_block "Block skip test" do
  path            "http://localhost:5678/ephemerals/not-here-dont-care"
  on_failure      :pass
end

noah_block "Block fail test" do
  path            "http://localhost:5678/ephemerals/not-here"
  timeout         600
  retry_interval  5
  on_failure      :fail
end
