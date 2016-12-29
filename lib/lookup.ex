defmodule Lookup do
  use Application

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "No arguments given"
  end

  def process(:help) do
    IO.puts """

      usage: lookup foo         -- lookup notes containing 'foo'
             lookup foo bar     -- lookup notes containing 'foo' and 'bar'
             lookup --add magic :: It does not exist
                                -- add a note with title 'magic' and body 'It does not exist'
             lookup -a ...      -- short form of 'lookup --add'
    """

  end


  def process(arg) do
    [title, content] = String.split( arg, ["::"]) |> Enum.map(fn x -> String.trim(x) end)
    Lookup.Note.add(title, content)
  end

  def parse_args(argv) do

    parse = OptionParser.parse(argv, switches: [help: :boolean, add: :boolean], aliases: [h: :help, a: :add])

    case parse do

      { [help: true], _, _ } -> :help
      { [add: true], list, _ } -> Enum.join(list, " ")
      { _, list, _ } -> Enum.join(list, " ")
      _ -> :help

    end

  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Lookup.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Lookup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
