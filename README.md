# ~ Under Construction ~

The following is a rough guide to the project until its components are finalised.

---

# A Modern Data Stack w/ Meltano

> uv, git, zsh, Python, SQL, Docker (soon), Meltano, DuckDB, dbt, Apache Superset

## Environment Setup

- rename `.env.example` to `.env` and fill with desired values
- create an empty .duckdb file in /duckdb ( `duckdb jaffle_shop.duckdb` )
- use uv to create the venv ( `uv venv .venv` and `uv sync` )
- use direnv to load .env in venv ( `direnv allow` and `direnv reload` when making changes in .env)

## DuckDB

- `duckdb jaffle_shop.duckdb` (create the database file)
- `duckdb jaffle_shop.duckdb --ui` (opens duckdb ui)
- use `.exit` or `.quit` to exit the CLI.

## Meltano

- `meltano run tap-faker target-duckdb` (data ingestion)
- `meltano invoke dbt-duckdb:deps` (install dbt packages)
- `meltano invoke dbt-duckdb:build` (data transformation)
- `meltano run etl` (full ETL job defined in meltano.yml)
- `meltano run dbt_docs` (creates dbt documentation and dag)

## dbt project

(to be updated)

## Superset

- `meltano install` (install all plugins, run with `--clean` for a fresh re-install)
- `meltano invoke superset:initialize` (initializes superset db, run with `--force` after first time)
- `meltano invoke superset:create-admin` (first time only)
- To automatically register the .duckdb file run the following.
  `meltano invoke superset shell` and `exec(open("analyze/superset/register_duckdb.py").read())`

  or in one command (should be working):

  meltano invoke superset shell <<'EOF'
  exec(open("analyze/superset/register_duckdb.py").read())
  EOF

  Otherwise configure the connection manualy in the DuckDB ui.

- `meltano invoke superset:ui` (to launch superset ui —> http://127.0.0.1:8088/)
- (sample dashboard to be added soon)
