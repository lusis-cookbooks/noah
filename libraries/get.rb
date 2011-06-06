require 'json'
require 'uri'
require 'net/http'
require 'timeout'

module Lusis
  module Noah
    def noah_get(noah_path, opts={})
      opts[:timeout] ||= node['noah']['client']['timeout']
      opts[:on_failure] ||= node['noah']['client']['on_failure']
      opts[:retry_interval] ||= node['noah']['client']['retry_interval']
      @net_timeout, @on_failure, @retry_interval = opts[:timeout],opts[:on_failure],opts[:retry_interval]
      @path = noah_path
      begin
        timeout(@net_timeout) do
          Chef::Log.info("Looking up data from #{noah_path}")
          handle_response
        end
      rescue Timeout::Error
        Chef::Application.fatal!("Noah server did not return a result in the allotted time")
      rescue Errno::ECONNREFUSED
        if @on_failure == :retry
          Chef::Log.info("Noah server unreachable, Retrying in #{@retry_interval} seconds")
          sleep @retry_interval
          retry
        else
          Chef::Application.fatal!("Noah server unreachable. Exiting")
        end
      end
    end

    private
    def query_noah
      Chef::Log.debug("Ohai. Iz askin' Noah fer somefin")
      uri = URI.parse(@path)
      resp = Net::HTTP.get_response(uri)
    end

    def handle_response
      res = query_noah
      case res.code
      when "500"
        Chef::Application.fatal!("Noah server returned an error (500): #{res.body}")
      when "404"
        Chef::Log.info("Noah server returned an error (404): #{res.body}")
        data = {}
      when "200"
        Chef::Log.info("Path #{@path} read successfully!")
        Chef::Log.debug("Message response: #{res.body}")
        data = res.body
        Chef::Application.fatal!("Empty data returned") if data.empty?
        begin
          JSON.parse(data)
        rescue JSON::ParserError
          Chef::Log.warn("Data not in JSON format. Returning Raw")
          data
        end
      else
        # It's impossible to see this since everything in Noah is either 200,404 or 500....
        Chef::Application.fatal!("Noah server returned an error (#{res.code}): #{res.body}")
      end
    end
  end
end
