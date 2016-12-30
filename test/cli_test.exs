defmodule CliTest do

  use ExUnit.Case
  doctest Lookup

  import Lookup, only: [ parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "one value returned as list if one given" do
    assert parse_args(["foo"]) == {:title, ["foo"]}
  end

  test "two values returned as list if two given" do
    assert parse_args(["foo", "bar"]) == {:title, ["foo", "bar"]}
  end

  test "one value returned as list if one given with option :add" do
    assert parse_args(["--add", "foo"]) == {:add, "foo"}
    assert parse_args(["-a", "foo"]) == {:add, "foo"}
  end

  test "two values returned as list if two given with option :add" do
    assert parse_args(["--add", "foo", "bar"]) == {:add, "foo bar"}
    assert parse_args(["-a", "foo", "bar"]) == {:add, "foo bar"}
  end

end
