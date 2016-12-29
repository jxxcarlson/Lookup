defmodule Lookup.Repo.Migrations.UseTextNotString do
  use Ecto.Migration

  def change do
  alter table(:notes) do
    modify :content, :text
  end

  end


end
