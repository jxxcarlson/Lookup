defmodule Lookup do
  use Application
  import Ecto.Query

  def main(args) do
    args |> parse_args |> process
  end

  ## PARSE ##

  @doc """
  Analyze the list of arguments and options supplied by the user and
  return an atom or tuple that can be processed to carry out an action.

  # Example 1
  iex > Lookup.parse_args(["--help"])
  :help

  # Example 2
  iex > Lookup.parse_args(["--add", "Shakespeare", "::", "an", "English", "playright"])
        {:add, "Shakespeare :: an English playright"}

  # Example 3
  Lookup.parse_args(["--title", "Shakespeare"])
  {:title, "Shakespeare"}

  # Example 4
  iex > Lookup.parse_args(["Shakespeare"])
  {:title, "Shakespeare"}
"""

  def parse_args(argv) do

      parse = OptionParser.parse(argv, switches:
        [help: :boolean,
        add: :boolean,
        title: :boolean,
        text: :boolean,
        count: :boolean],
        aliases: [h: :help, a: :add, t: :title, T: :text])

      case parse do

        { [help: true], _, _ } -> :help
        { [count: true], _, _ } -> :count
        { [add: true], list, _ } -> {:add, Enum.join(list, " ")}
        { [title: true], list, _ } -> {:title, list}
        { [text: true], list, _ } -> {:text, list}
        { _, list, _ } -> {:text, list}

        _ -> :help

      end

    end


  ## PROCESS ##

  def process([]) do
    IO.puts "No arguments given"
  end

  @doc """
  Display user help
  """
  def process(:help) do
    IO.puts """

      lookup foo              -- lookup notes containing 'foo' in text or contents
      lookup foo bar          -- lookup notes containing 'foo' and 'bar' in text or contents
      lookup --title foo      -- search for notes with 'foo' in title
      lookup --text foo       -- search for notes with 'foo' in text or contents
      lookup --text foo bar   -- search for notes with 'foo and bar' in text or contents
      lookup --add Magic :: It does not exist.
                              -- add a note with title 'Magic' and body 'It does not exist,'

      lookup -a ...           -- short form of 'lookup --add'
      lookup -t ...           -- short form of 'lookup --title'
      lookup -T ...           -- short form of 'lookup --text'

      ---
      * Not yet implemented
    """

  end


  @doc """
  process({:add, arg}) -- Add the element specified by 'arg' to the database.  It is assumened that arg is a string
  of the form "TiTLE :: CONTENT".  This string is first split into TITLE and CONTENT,
  after which Lookup.Note.add(TiTLE, CONTENT) is called.
  """
  def process({:add, arg}) do
    [title, content] = String.split( arg, ["::"]) |> Enum.map(fn x -> String.trim(x) end)
    Lookup.Note.add(title, content)
    IO.puts "Added: #{title}"
  end

  @doc """
  process({:title, arg}) -- Search for records with title matching arg.  The match is
  case insenstie and not strict.  Thus "speed" matches "Speed of light"
  """
  def process({:title, arg}) do
    notes = Ecto.Query.from(p in Lookup.Note, where: ilike(p.title, ^"%#{List.first(arg)}%"))
    |> Lookup.Repo.all

    notes |> Enum.map(fn x -> x.title <> ":: " <> x.content end)
    |> Enum.map(fn x -> IO.puts "\n" <> x end)

    IO.puts "---"
    IO.puts Enum.count(notes)
    IO.puts ""
  end

  @doc """
  process({:text, arg}) -- Search for records with text or title matching arg.  The match is
  case insenstie and not strict.  Thus "speed" matches "Speed of light"
  """
  def process({:text, arg}) do
    notes = Ecto.Query.from(p in Lookup.Note, where: ilike(p.title, ^"%#{List.first(arg)}%") or ilike(p.content, ^"%#{List.first(arg)}%"))
    |> Lookup.Repo.all
    |> Lookup.Note.filter_records_with_term_list(tl(arg))

    notes |> Enum.map(fn x -> x.title <> ":: " <> x.content end)
    |> Enum.map(fn x -> IO.puts "\n" <> x end)

    IO.puts "---"
    IO.puts Enum.count(notes)
    IO.puts ""
  end

  def process(:count) do
   # from p in Lookup.Note, select: count(p.id)
    notes = Lookup.Repo.all(Lookup.Note)
    IO.puts Enum.count(notes)
   # IO.inspect(foo)
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
