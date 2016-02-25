# connect to required REST services
class Connector
  require 'net/http'
  require 'uri'

  attr_accessor :uri

  def gather
    begin
      http              = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl      = false
      start_time        = Time.now
      request           = Net::HTTP::Get.new(@uri.request_uri)
      elapsed_time      = Time.now - start_time
      # puts "request took #{elapsed_time}"
      response          = http.request request
      @my_status        = JSON.parse(response.body)
    rescue JSON::ParserError
      puts '*** This job either does not exist or has never been built ***'
      @my_status = 'ParseError'
    end
    @my_status
  end
end
