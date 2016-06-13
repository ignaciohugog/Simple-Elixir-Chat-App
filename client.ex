defmodule Client do
@moduledoc """
The user functions are:
- connect to a server
- chat
- notify seen
- read msg (short period of time)
- answear msg (short period of time)
- notify writing
- mute user
- create brodcast (talk with all available users)
- notify finshing reading
"""

  def start do
    spawn fn -> loop [] end
  end

  def loop(users) do
    receive do
      {:connect, server, name} ->
        send server, {:connect, self, name}
        loop users

      {:update, users} ->
        IO.inspect(users)
        loop users

      {:send, from, msg} ->
        IO.puts "[Client] #{Dict.get(users, from)} says: #{msg}"
        send from, {:seen, self, "has seen [#{msg}]"}
        loop users

      {:seen, from, msg} ->
        IO.puts "[Client] #{Dict.get(users, from)}: #{msg}"
        loop users
    end
  end
end