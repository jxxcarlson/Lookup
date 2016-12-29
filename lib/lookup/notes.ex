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

end
