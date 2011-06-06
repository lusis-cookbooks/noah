%w{host service configuration ephemeral get block}.each do |r|
  include_recipe "noah::#{r}_test"
end
