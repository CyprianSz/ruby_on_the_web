require 'socket'
require 'json'

host = 'localhost'
port = 2000

puts "Send \"GET\" or \"POST\" request ?"
type = gets.chomp.upcase

until type.match /^GET$|^POST$/
	puts "\nWrong input."
	puts "Choose \"GET\" or \"POST\" request."
	type = gets.chomp.upcase
end

if type == "GET"
	path = 'index.html'
	request = "GET #{path} HTTP/1.0\r\n\r\n"
elsif type == "POST"
	params = {:viking => {} }
	path = 'thanks.html'
	puts 'Enter name:'
	params[:viking][:name] = gets.chomp
	puts 'Enter e-mail:'
	params[:viking][:email] = gets.chomp
	request = "POST #{path} HTTP/1.0\r\n
						 Content-Length: #{params.to_json.size}\r\n\r\n
						 #{params.to_json}"
end

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
headers, body = response.split("\r\n\r\n", 2)
response_message = headers.split(" ", 3)
status_code = response_message[1]
status_desc = response_message[2]

case status_code
	when '200' then puts body
	when '400' then puts "Error #{status_code}: #{status_desc}"
end