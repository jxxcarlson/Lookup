defmodule Lookup.Note do
  use Ecto.Schema

  schema "notes" do
    field :title, :string
    field :content, :string
  end

  def changeset(note, params \\ %{}) do
    note
    |> Ecto.Changeset.cast(params, [:title, :content])
    |> Ecto.Changeset.validate_required([:title, :content])
  end

  @doc """
  Add record with given title and contents to the database

  ## Example
  > iex Lookup.Note.add("Bohr radius", "5.29177e-11 meters")
  {:ok,
   %Lookup.Note{__meta__: #Ecto.Schema.Metadata<:loaded, "notes">,
    content: "5.29177e-11 meters", id: 24, title: "Bohr radius"}}
  """

  def add(title \\ "Untitled", content) do
    note = %Lookup.Note{}
    _changeset = changeset(note, %{title: title, content: content})
    Lookup.Repo.insert(_changeset)
  end

  ################

  def filter_list_with_term(list, term) do

    Enum.filter(list, fn(x) -> String.contains?(x, term) end)

  end


  def filter_list_with_term_list(list, term_list) do

    case {list, term_list} do
      {list,[]} -> list
      {list, term_list} -> filter_list_with_term_list( filter_list_with_term(list, hd(term_list)), tl(term_list) )
    end

  end

  ################

  def filter_records_with_term(list, term) do

    Enum.filter(list, fn(x) -> String.contains?(x.title, term) or String.contains?(x.content, term) end)

  end

  def filter_records_with_term_list(list, term_list) do

    case {list, term_list} do
      {list,[]} -> list
      {list, term_list} -> filter_records_with_term_list(
            filter_records_with_term(list, hd(term_list)), tl(term_list)
          )
    end

  end

end
