defmodule LookupTest do
  use ExUnit.Case
  require Ecto.Query
  doctest Lookup

  import Lookup, only: [ parse_args: 1]

    test "filter_list_with_term selects the correct sublist" do
      list1 = ["ax by cz", "cz du eu", "du eu fu gu hu"]
      assert Lookup.Note.filter_list_with_term(list1, "cz") == ["ax by cz", "cz du eu"]
    end

    test "filter_list_with_term_list selects the correct sublist" do
       list1 = ["ax by cz", "cz du eu", "du eu fu gu hu"]
       assert Lookup.Note.filter_list_with_term_list(list1, ["cz", "du"]) == ["cz du eu"]
    end

    test "filter_records_with_term rselects the correct sublist" do
      arg = ["trill"]
      records = Ecto.Query.from(p in Lookup.Note, where: ilike(p.content, ^"%#{List.first(arg)}%")) |> Lookup.Repo.all
      assert length(records) == 3
      assert length(Lookup.Note.filter_records_with_term(records, "100"))  == 1
     end

     test "filter_records_with_term_list rselects the correct sublist when there is one term" do
       arg = ["trill"]
       records = Ecto.Query.from(p in Lookup.Note, where: ilike(p.content, ^"%#{List.first(arg)}%")) |> Lookup.Repo.all
       assert length(records) == 3
       assert length(Lookup.Note.filter_records_with_term_list(records, ["100"]))  == 1
     end

     test "filter_records_with_term_list rselects the correct sublist when there are two identical terms" do
       arg = ["trill"]
       records = Ecto.Query.from(p in Lookup.Note, where: ilike(p.content, ^"%#{List.first(arg)}%")) |> Lookup.Repo.all
       assert length(records) == 3
       assert length(Lookup.Note.filter_records_with_term_list(records, ["100", "100"]))  == 1
     end

     test "filter_records_with_term_list rselects the correct sublist when there are two distinct terms" do
       arg = ["c"]
       records = Ecto.Query.from(p in Lookup.Note, where: ilike(p.content, ^"%#{List.first(arg)}%")) |> Lookup.Repo.all
       assert length(records) == 22
       assert length(Lookup.Note.filter_records_with_term_list(records, ["1", "c"]))  == 1
     end
  
end
