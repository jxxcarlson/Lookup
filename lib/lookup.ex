defmodule Lookup do
  use Application
  import Ecto.Query

  def main(args) do
    args |> parse_args |> process
  end

  ## PARSE ##

  def parse_args(argv) do

      parse = OptionParser.parse(argv, switches:
        [help: :boolean, add: :boolean, title: :boolean],
        aliases: [h: :help, a: :add, t: :title])

      case parse do

        { [help: true], _, _ } -> :help
        { [add: true], list, _ } -> {:add, Enum.join(list, " ")}
        { [title: true], list, _ } -> {:title, List.first(list)}
        _ -> :help

      end

    end


  ## PROCESS ##

  def process([]) do
    IO.puts "No arguments given"
  end

  def process(:help) do
    IO.puts """

      usage: lookup foo             -- lookup notes containing 'foo'
             lookup foo bar         -- lookup notes containing 'foo' and 'bar'
             lookup --title foo     -- search for notes with titel 'foo'
             lookup --add Magic :: It does not exist.
                                    -- add a note with title 'Magic' and body 'It does not exist,'

             lookup -a ...          -- short form of 'lookup --add'
             lookup -t ...          -- short form of 'lookup --title'
    """

  end


  def process({:add, arg}) do
    [title, content] = String.split( arg, ["::"]) |> Enum.map(fn x -> String.trim(x) end)
    Lookup.Note.add(title, content)
  end

  def process({:title, arg}) do
    # Lookup.Note
    # |> Lookup.Repo.all(from p in Lookup.Note, where: ilike(p.title, ^"%#{arg}%"))
    Ecto.Query.from(p in Lookup.Note, where: ilike(p.title, ^"%#{arg}%"))
    # |> Ecto.Query.where(title: ^arg)
    |> Lookup.Repo.all
    |> Enum.map(fn x -> x.title <> ":: " <> x.content end)
    |> Enum.map(fn x -> IO.puts "\n" <> x end)
    IO.puts ""
    # |> IO.inspect
  end


  ## START ##

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Lookup.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Lookup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
