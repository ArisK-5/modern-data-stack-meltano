# ~ Under Construction ~

The following is a rough guide to the project until its components are finalised.

---

# A Modern Data Stack w/ Meltano

> uv, git, zsh, Python, SQL, Docker (soon), Meltano, DuckDB, dbt, Apache Superset

![Modern Data Stack w/ Meltano](/assets/images/architecture.png "the architecture of the project")

## Environment Setup

- rename `.env.example` to `.env` and fill with desired values
- use uv to create the virtual environment ( `uv venv .venv` ) and install dependencies ( `uv sync` )
- use direnv to load the .env file in the virtual environment ( `direnv allow` )

After making changes in .env remember to reload the environment variables ( `direnv reload` )

## DuckDB

In the `/duckdb` folder:

- `duckdb jaffle_shop.duckdb` (create an empty database file)
- `duckdb jaffle_shop.duckdb --ui` (connect to the database in the DuckDB ui)

Use `.quit` or `.exit` to exit the CLI and severe the database connection.

Improtant note on DuckDB's [concurrency](https://duckdb.org/docs/stable/connect/concurrency).

## Meltano

- `meltano install` (install all plugins, run with `--clean` for a fresh re-install)
- `meltano run tap-faker target-duckdb` (data ingestion / EXTRACT LOAD)
- `meltano invoke dbt-duckdb:deps` (install dbt packages)
- `meltano invoke dbt-duckdb:build` (data transformation / TRANSFORM)
- `meltano run elt` (custom ELT job defined in meltano.yml)
- `meltano run dbt_docs` (custom job defined in meltano.yml for generating dbt documentation and dag)

## dbt project (to be updated)

The models used in this project were taken from Meltano's [Jaffle Shop Template](https://github.com/meltano/jaffle-shop-template).

![The dbt DAG of the project](/assets/images/dbt_dag.png "dbt DAG of the project")

## Superset

- `meltano invoke superset:initialize` (initialize Superset db, run with `--force` after configuration changes)
- `meltano invoke superset:create_admin_user` (first time only)
- `meltano invoke superset:import_sample_dashboard` (import the sample dashboard that comes with the project)
  This will also automatically create the database connection with DuckDB and create the Datasets inside Superset.
- If you don't want to import the dashboard you can still remotely create the DuckDB connection by running the following:

  `meltano invoke superset shell` and then `exec(open("analyze/superset/register_duckdb.py").read())`

  Otherwise, configure the connection manually in the DuckDB ui.

- `meltano invoke superset:ui` (to launch [Superset ui](http://127.0.0.1:8088/))

## Future Improvements

- CI/CD workflows
- Add an orchestrator
- Containerization
- Multiple deployments
- Improve Superset Dashboard with more in-depth charts and analysis
- Makefile ?

---
