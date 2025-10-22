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
- `meltano run elt` (custom ELT job defined in meltano.yml)
- `meltano run dbt_docs` (dbt documentation and dag custom job defined in meltano.yml)

## dbt project (to be updated)

The dbt models used in this project were taken from Meltano's [Jaffle Shop Template](https://github.com/meltano/jaffle-shop-template)

![The dbt DAG of the project](/assets/images/dbt_dag.png "dbt DAG of the project")

## Superset

- `meltano invoke superset:initialize` (initializes superset db, run with `--force` after configuration changes)
- `meltano invoke superset:create_admin_user` (first time only)
- `meltano invoke superset:import_sample_dashboard` (import the sample dashboard that comes with the project)
  This will also automatically create the database connection with DuckDB and create the Datasets inside Superset.
- If you don't want to import the dashboard you can still remotely create the DuckDB connection by running the following:

  `meltano invoke superset shell` and then `exec(open("analyze/superset/register_duckdb.py").read())`

  Otherwise, configure the connection manually in the DuckDB ui.

- `meltano invoke superset:ui` (to launch Superset ui —> http://127.0.0.1:8088/)

## Future Improvements

- CI/CD workflows
- Add an orchestrator
- Containerization
- Multiple deployments
- Improve Superset Dashboard with more in-depth charts and analysis
- Makefile ?

---
