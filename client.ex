defmodule Client do
@moduledoc """
- connect to a server
- update users list
- write
- notify writing
- read chats messages storaged
- mute user
- notify seen
- create brodcast (talk with all available users)
"""

  def start do
    spawn fn -> loop %{}, %{}, %{} end
  end

  def loop(users, chats, muted) do
    receive do
      {:connect, server, name} ->
        send server, {:connect, self, name}
        loop users, chats, muted

      {:update, users} ->
        loop users, chats, muted

      {:brodcast, group, msg} ->
        Enum.each(group, fn(u) -> send u, {:receive, self, msg} end)
        loop users, chats, muted

      {:write, recipient, msg} ->
        send recipient, {:writting, Dict.get(users, self)}
        :timer.sleep(10000)
        send recipient, {:receive, self, msg}
        loop users, chats, muted

      {:writting, user} ->
        IO.puts "[#{Dict.get(users, self)}] #{user} is writting"
        loop users, chats, muted

      {:receive, sender, msg} ->
        if !Dict.has_key?(muted, sender), do:
         IO.puts "[#{Dict.get(users, self)}] #{Dict.get(users, sender)} says: #{msg}"
        send sender, {:sent, msg}
        loop users, (Dict.put_new chats, sender, msg), muted

      {:sent, msg} ->
        IO.puts "[#{Dict.get(users, self)}] #{msg} received"

      {:read} ->
        if Enum.empty?(chats) do
          IO.puts "[#{Dict.get(users, self)}] nothing to read"
        else
          {sender, msg} = Enum.random(chats)
          IO.inspect("[#{Dict.get(users, self)}] reading #{Dict.get(users, sender)} messages")
          send sender, {:seen, self, msg}
          chats = Dict.delete(chats, sender)
        end
        loop users, chats, muted

      {:seen, from, msg} ->
        IO.puts "[#{Dict.get(users, self)}] #{Dict.get(users, from)} has seen: #{msg}"
        loop users, chats, muted

      {:mute, user} ->
        loop users, chats, (Dict.put_new muted, user, "")

      after 10_000 ->
        send self, {:read}
        loop users, chats, muted
    end
  end
end