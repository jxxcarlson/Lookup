defmodule Lookup.Note do
  use Ecto.Schema
  import Ecto.Query

  # https://github.com/devinus/poison

  @derive [Poison.Encoder]
    # defstruct [:title, :content, :inserted_at, :updated_at]

  schema "notes" do
    field :title, :string
    field :content, :string

    timestamps
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
    changeset(%Lookup.Note{}, %{title: title, content: content})
    |> Lookup.Repo.insert
  end

  def search_by_title(arg) do
    Ecto.Query.from(p in Lookup.Note, where: ilike(p.title, ^"%#{List.first(arg)}%"))
    |> Lookup.Repo.all
    |> Enum.map(fn x -> x.title <> ":: " <> x.content end)
  end

  def search(arg) do
    Ecto.Query.from(p in Lookup.Note, where: ilike(p.title, ^"%#{List.first(arg)}%") or ilike(p.content, ^"%#{List.first(arg)}%"))
    |> Lookup.Repo.all
    |> Lookup.Note.filter_records_with_term_list(tl(arg))
    |> Enum.map(fn x -> x.title <> ":: " <> x.content end)
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

   ################



   ################

  def to_struct(record) do
    %{  title: record.title,
        content: record.content,
        inserted_at: record.inserted_at,
        updated_at: record.updated_at
    }
  end

  def to_JSON(record) do
      "{\"title\": \"#{record.title}\", \"content\": \"#{record.content}\", \"inserted_at\": \"#{record.inserted_at}\", \"updated_at\": \"#{record.updated_at}\"}"
    end

  def record_to_JSON(id) do
    Lookup.Note
    |> Lookup.Repo.get(id)
    |> to_struct
    |> Poison.encode!
  end

  def string_to_JSON(str) do
     Poison.decode!(str)
  end

  def insert_from_json(str) do
    json = string_to_JSON(str)
    Lookup.Note.add(json["title"], json["content"])
  end

  def random(p \\ 10) do
    {_ok, result} = Ecto.Adapters.SQL.query(Lookup.Repo, "SELECT title, content FROM notes TABLESAMPLE BERNOULLI(#{p})")
    result.rows
  end

end
