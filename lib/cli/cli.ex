defmodule Lookup.CLI do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def main(args) do
   args |> parse_args |> process
  end

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is sequence of words separated by spaces which are used to
  perform a conjunctive lookup of the Lookup database.  This sequence is
  returned as a list

  Return a list of `[word1, word2, ...]`, or `help:` if help was given.
  """

  def parse_args(argv) do

    parse = OptionParser.parse(argv, switches: [help: :boolean, add: :boolean], aliases: [h: :help, a: :add])

    case parse do

      { [help: true], _, _ } -> :help
      { [add: true], list, _ } -> Enum.join(list, " ")
      { _, list, _ } -> Enum.join(list, " ")
      _ -> :help

    end

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

  def process({:add, arg}) do
    Lookup.Note.add("Untitled", arg)
  end



end
