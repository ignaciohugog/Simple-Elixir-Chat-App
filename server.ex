
defmodule Server do 
@doc """
The server functions are:
- receive new users 
- storage new users
- retrieve for each new user a list of availables users 
- update users state to the already connected users 
  (user connects/disconnects)
"""

	def init do
		spawn(Server, :incoming_user,[%{}])	
	end

	def incoming_user(users) do
		receive do 
			{from, user_name} ->	
				IO.puts("New user!")
				notifyUsers(users, {from, user_name})				
				incoming_user(Dict.put_new(users, from, user_name))
			end
	end

	def notifyUsers(users, newUser) do
		#TODO
		#for each users notify the new connection (new user)
		IO.puts("notify users!, current:")
		IO.inspect(users)
		IO.inspect(newUser)
	end
end

