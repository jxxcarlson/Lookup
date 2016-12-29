defmodule Lookup.Repo.Migrations.CreateLookupTable do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :content, :string
    end
  end
  
end
