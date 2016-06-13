defmodule Server do
@moduledoc """
- receive new users
- storage new users
- update users list for each one
"""

  def start do
    spawn fn -> loop %{} end
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


#--Basic test--
# c("Server.ex")
# c("Client.ex")
# s = Server.start
# c1 = Client.start
# c2 = Client.start
# c3 = Client.start
# send c1, {:connect, s, "nam1"}
# send c2, {:connect, s, "nam2"}
# send c3, {:connect, s, "nam3"}
# send c2, {:write, c1, "hello from c1"}
# send c3, {:write, c1, "hello from c2"}

#--Muted test--
# c("Server.ex")
# c("Client.ex")
# s = Server.start
# c1 = Client.start
# c2 = Client.start
# c3 = Client.start
# send c1, {:connect, s, "nam1"}
# send c2, {:connect, s, "nam2"}
# send c3, {:connect, s, "nam3"}
# send c1, {:mute, c2}
# send c2, {:write, c1, "hello from c2"}

#--Brodcast test--
# c("Server.ex")
# c("Client.ex")
# s = Server.start
# c1 = Client.start
# c2 = Client.start
# c3 = Client.start
# send c1, {:connect, s, "nam1"}
# send c2, {:connect, s, "nam2"}
# send c3, {:connect, s, "nam3"}
# send c1, {:brodcast, [c2,c3], "hello word"}

