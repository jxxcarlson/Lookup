defmodule Lookup.Repo.Migrations.AddTimestamps do
  use Ecto.Migration

  def change do
        alter table(:notes) do
            timestamps default: "2016-01-01 00:00:01"
      end

  end
end
