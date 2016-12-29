defmodule Lookup.Note do
  use Ecto.Schema

  @doc """
  Usage: Lookup.Note.add("Speed of sound", "343 meters/sec @ STP")
  """

  schema "notes" do
    field :title, :string
    field :content, :string
  end

  def changeset(note, params \\ %{}) do
    note
    |> Ecto.Changeset.cast(params, [:title, :content])
    |> Ecto.Changeset.validate_required([:title, :content])
  end

  def add(title \\ "Untitled", content) do
    note = %Lookup.Note{}
    _changeset = changeset(note, %{title: title, content: content})
    Lookup.Repo.insert(_changeset)
  end

end
