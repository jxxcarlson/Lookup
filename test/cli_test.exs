defmodule CliTest do

  use ExUnit.Case
  doctest Lookup

  import Lookup, only: [ parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "one value returned as list if one given" do
    assert parse_args(["foo"]) == "foo"
  end

  test "two values returned as list if two given" do
    assert parse_args(["foo", "bar"]) == "foo bar"
  end

  test "one value returned as list if one given with option :add" do
    assert parse_args(["--add", "foo"]) == "foo"
    assert parse_args(["-a", "foo"]) == "foo"
  end

  test "two values returned as list if two given with option :add" do
    assert parse_args(["--add", "foo", "bar"]) == "foo bar"
    assert parse_args(["-a", "foo", "bar"]) == "foo bar"
  end

end
