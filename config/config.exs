use Mix.Config

config :lookup, Lookup.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "lookup_repo",
  user: "postgres",
  hostname: "localhost"

config :lookup, ecto_repos: [Lookup.Repo]
