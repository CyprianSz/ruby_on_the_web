require 'socket'
require 'json'

server = TCPServer.open(2000)

loop do
  client = server.accept
  request = client.read_nonblock(1024)
  headers, body = request.split("\r\n\r\n", 2)
  request_line = headers.split
  request_type = request_line[0]
  path = request_line[1]
  version = request_line[2]

  if File.exist?(path)
    response = File.open(path)

    if request_type == 'GET'
      client.print "#{version} 200 OK\r\n
                    Date: #{Time.now.ctime}\r\n
                    Content-Length: #{response.size}\r\n\r\n
                    #{response.read}"
    elsif request_type == 'POST'
      params = JSON.parse(body)
      client.print "#{version} 200 OK\r\n
                    Date: #{Time.now.ctime}\r\n\r\n"
      client.print response.read.gsub("<%= yield %>", 
                                      "<li>Name: #{params['viking']['name']}</li>
                                      <li>E-mail: #{params['viking']['email']}</li>")
    end
    
  else      
    client.puts "#{version} 404 Not Found"
  end

  client.close
end