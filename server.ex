#TODO:STRUCTS
#LIB COMMONS
#FORMAT AND CONVENTIONS

defmodule Server do
@moduledoc """
The server functions are:
- receive new users 
- storage new users
- update users list for each one
"""

	def start do
		spawn fn -> loop(%{}) end
	end


	def loop(users) do
		receive do 
			{:connect, from, name} ->	
				IO.puts "[Server] #{name} joins to the chat"
				new_users = Dict.put_new users, from, name
				Enum.each(new_users, fn({s,_}) -> send s, {:update, new_users} end)
				loop new_users
			end
	end
end



# c("Server.ex")
# c("Client.ex")
# s = Server.start
# c1 = Client.start
# c2 = Client.start
# send c1, {:connect, s, "nam1"}
# send c2, {:connect, s, "nam2"}
# send c1, {:send, c2, "helloo"}
