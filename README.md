# ~ Under Construction ~

The following is a rough guide to the project until its components are finalised.

---

# A Modern Data Stack w/ Meltano

> uv, git, zsh, Python, SQL, Docker (soon), Meltano, DuckDB, dbt, Apache Superset

## Environment Setup

- rename `.env.example` to `.env` and fill with desired values
- create an empty .duckdb file in /duckdb ( `duckdb jaffle_shop.duckdb` )
- use uv to create the venv ( `uv venv .venv` and `uv sync` )
- use direnv to load the .env file in the virtual environment ( `direnv allow` )
  -> after making changes in .env remember to reload ( `direnv reload` )

## DuckDB

In the `/duckdb` folder:

- `duckdb jaffle_shop.duckdb` (create the database file)
- `duckdb jaffle_shop.duckdb --ui` (opens duckdb ui)
- use `.exit` or `.quit` to exit the CLI.

## Meltano

- `meltano install` (installs all plugins, run with `--clean` for a fresh re-install)
- `meltano run tap-faker target-duckdb` (data ingestion / EXTRACT LOAD)
- `meltano invoke dbt-duckdb:deps` (install dbt packages)
- `meltano invoke dbt-duckdb:build` (data transformation / TRANSFORM)
- `meltano run elt` (full ELT job defined in meltano.yml)
- `meltano run dbt_docs` (dbt documentation and dag job defined in meltano.yml)

## dbt project

(to be updated)

## Superset

- `meltano invoke superset:initialize` (initializes superset db, run with `--force` after configuration changes)
- `meltano invoke superset:create-admin` (first time only)
- To automatically register the .duckdb file run the following.
  `meltano invoke superset shell` and `exec(open("analyze/superset/register_duckdb.py").read())`

  or in one command (should be working):

  ```
  meltano invoke superset shell <<'EOF'
  exec(open("analyze/superset/register_duckdb.py").read())
  EOF
  ```

  Otherwise, configure the connection manually in the DuckDB ui.

- To import a sample dashboard I made, run:
  ```
  meltano invoke superset superset import-dashboards \
    -p analyze/superset/dashboards/business_and_customer_insights.zip \
    -u admin`
  ```
  Otherwise, import manually in the Superset ui.
- `meltano invoke superset:ui` (to launch Superset ui —> http://127.0.0.1:8088/)
