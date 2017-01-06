defmodule Lookup do
  use Application
  alias Lookup.Repo
  alias Lookup.Note

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
        count: :boolean,
        random: :boolean,
        sample: :boolean],

        aliases: [
            h: :help,
            a: :add,
            t: :title,
            T: :text,
            c: :count,
            r: :random,
            s: :sample])

      case parse do

        { [help: true], _, _ } -> :help
        { [count: true], _, _ } -> :count
        { [random: true], _, _} -> :random
        { [add: true], list, _ } -> {:add, Enum.join(list, " ")}
        { [title: true], list, _ } -> {:title, list}
        { [text: true], list, _ } -> {:text, list}
        { [sample: true], list, _ } -> {:sample, list}
        { _, list, _ } -> {:text, list}
        _ -> :help


      end

    end


  ## PROCESS ##


  def display(notes) do
    notes |> Enum.map(fn x -> IO.puts "\n" <> x end)
    IO.puts "------"
    IO.puts Enum.count(notes)
    IO.puts ""
  end

  def display(notes, n) do
      notes |> Enum.map(fn x -> IO.puts "\n" <> x end)
      IO.puts "------"
      IO.puts "#{Enum.count(notes)}/#{n}"
      IO.puts ""
    end

  def process([]) do
    IO.puts "No arguments given"
  end

  @doc """
  Display user help
  """
  def process(:help) do
    IO.puts """

      lookup --title foo      -- search for notes with 'foo' in title

      lookup foo              -- search for notes containing 'foo' in text or contents
      lookup foo bar          -- search for notes containing 'foo' and 'bar' in text or contents
      lookup --sample foo     -- as above, but take a random sample of the notes found

      lookup --random         -- return random selection of all notes
      lookup --count          -- report number of notes in databasse

      lookup --add Magic :: It does not exist.
                              -- add a note with title 'Magic' and body 'It does not exist,'

      lookup -a ...           -- short form of 'lookup --add'
      lookup -c               -- short form of 'lookup --count'
      lookup -r               -- short form of 'lookup --random'
      lookup -s               -- short form of 'lookup --sample'
      lookup -t ...           -- short form of 'lookup --title'

    """

  end


  @doc """
  process({:add, arg}) -- Add the element specified by 'arg' to the database.  It is assumened that arg is a string
  of the form "TiTLE :: CONTENT".  This string is first split into TITLE and CONTENT,
  after which Lookup.Note.add(TiTLE, CONTENT) is called.
  """
  def process({:add, arg}) do
    String.split( arg, ["::"])
    |> Enum.map(fn x -> String.trim(x) end)
    |> case  do
       [title, content] -> [Note.add(title, content), IO.puts "Added: #{title}"]
       _ -> IO.puts "Error -- did you forget to put '::' ?"
    end
  end

  @doc """
  process({:title, arg}) -- Search for records with title matching arg.  The match is
  case insenstie and not strict.  Thus "speed" matches "Speed of light"
  """
  def process({:title, arg}) do
    Note.search_by_title(arg)
    |> display
  end

  @doc """
  process({:text, arg}) -- Search for records with text or title matching arg.  The match is
  case insenstie and not strict.  Thus "speed" matches "Speed of light"
  """
  def process({:text, arg}) do
    Note.search(arg) |> display
  end

  def process({:sample, arg}) do
      IO.puts "SAMPLING ..."
      sample_size = 4
      notes = Note.search(arg)
      n = length(notes)
      notes
      |> ListUtil.mmcut(sample_size)
      |> display(n)
    end


  def process(:count) do
    notes = Repo.all(Note)
    IO.puts Enum.count(notes)
  end

  def process(:random) do
    IO.puts ""
    Note.random
    |> Enum.map(fn (item) -> IO.puts(hd(item) <> ":: " <> hd(tl(item)) <> "\n") end)
  end


  ## START ##

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Lookup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
