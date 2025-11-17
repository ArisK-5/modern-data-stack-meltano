# A Modern Data Stack w/ Meltano -- local dev version

![Modern Data Stack w/ Meltano](/assets/diagrams/architecture.png "the architecture of the project")

---

## Table of Contents

- [Introduction](#introduction)
- [Environment Setup](#environment-setup)
- [DuckDB](#duckdb)
- [Meltano](#meltano)
- [dbt](#dbt)
- [Apache Superset](#apache-superset)
- [Future Improvements](#future-improvements)

---

## Introduction

This project implements a modern data stack leveraging open-source tools for building reproducible, [version-controlled](https://github.com/git-guides), and analytics-ready data pipelines. At its core, it uses [Meltano](https://meltano.com) to orchestrate ELT workflows, extracting data from sources (e.g., [JaffleShop generator](https://hub.meltano.com/extractors/tap-jaffle-shop/)), loading it into [DuckDB](https://duckdb.org), and transforming it with [dbt](https://www.getdbt.com/product/what-is-dbt). The transformed data is then visualized and explored using [Apache Superset](https://superset.apache.org).

Designed for development, experimentation, and future cloud deployment, this stack integrates best practices from DataOps. The project is structured to evolve with CI/CD pipelines, containerization, and cloud-based infrastructure while maintaining clarity and maintainability of data workflows.

The architectural diagram of the project was made using [Diagrams](https://diagrams.mingrammer.com) in [architecture.py](assets/architecture.py).

Technologies currently in use:

<center> uv | git | zsh | Python | SQL | Meltano | DuckDB | dbt | Apache Superset </center>

---

## Environment Setup

The project's local development was done using [uv](https://docs.astral.sh/uv/), an extremely fast Python package and project manager. Its configuration can be found in [pyproject.toml](pyproject.toml).

Setup instructions (run in project's root):

- rename `.env.example` to `.env` and fill with desired values
- use uv to create the virtual environment ( `uv venv .venv` ) and install dependencies ( `uv sync` )
- allow direnv to load the `.env` file in the virtual environment ( `direnv allow` )

After making changes in `.env` remember to reload the environment variables ( `direnv reload` )

[.envrc](.envrc) automatically loads all environment variables defined in the local `.env` file into the shell, then activates the project’s Python virtual environment located in `/.venv`.

---

## DuckDB

DuckDB is an in-process analytical database optimized for local analytics and fast OLAP-style queries. It stores data efficiently, integrates seamlessly with Python and SQL, and serves as the central analytical warehouse in this project.

Setup instructions (run in `/duckdb`):

- `duckdb jaffle_shop.duckdb` (create an empty database file)
- `duckdb jaffle_shop.duckdb --ui` (connect to the database in the DuckDB ui)

Use `.quit` or `.exit` to exit the CLI and severe the database connection.

Improtant note on DuckDB's [concurrency](https://duckdb.org/docs/stable/connect/concurrency).

--> **TLDR**; In order to access the data in Superset (or transform them with dbt) you need to sever any open connection to the database from the DuckDB UI. That's because DuckDB allows only one read-write connection at a time to the database and currently the DuckDB UI does not have a read-only mode. You could though make a read-only connection using the DuckDB CLI.

---

## Meltano

Meltano is an open-source DataOps platform that orchestrates the Extract, Load, and Transform (ELT) process. It enables reproducible, version-controlled data pipelines by integrating extractors, loaders, and transformers like dbt into a unified, developer-friendly workflow.

Setup instructions (run in `/meltano`):

- `meltano install` (install all plugins, run with `--clean` for a fresh re-install)
- `meltano run tap-faker target-duckdb` (data ingestion / EXTRACT LOAD)
- `meltano invoke dbt-duckdb:deps` (install dbt packages)
- `meltano invoke dbt-duckdb:build` (data transformation / TRANSFORM)
- `meltano run elt` (custom ELT job defined in meltano.yml)
- `meltano run dbt_docs` (custom job defined in meltano.yml for generating dbt documentation and dag)

---

## dbt

dbt (Data Build Tool) focuses on the Transform layer of the modern data stack. It allows analysts and engineers to transform raw data in the warehouse using modular SQL and Jinja templates, ensuring data models are tested, documented, and versioned alongside code.

The models used in this project were taken from Meltano's [Jaffle Shop Template](https://github.com/meltano/jaffle-shop-template).

![The dbt DAG of the project](/assets/diagrams/dbt_dag.png "dbt DAG of the project")

---

## Apache Superset

Apache Superset is an open-source business intelligence (BI) and data visualization platform. It connects directly to DuckDB to provide an interactive, web-based interface for exploring data, creating dashboards, and sharing insights.

Setup instructions (run in `/meltano`):

- `meltano invoke superset:initialize` (initialize Superset db, run with `--force` after configuration changes)
- `meltano invoke superset:create_admin_user` (first time only)
- `meltano invoke superset:import_sample_dashboard` (import the sample dashboard that comes with the project)

  This will also automatically create the database connection with DuckDB and create the Datasets (`orders` and `customers`) inside Superset.

> If you don't want to import the dashboard you can still remotely create the DuckDB connection by running the following:
>
> `meltano invoke superset shell` and then `exec(open("analyze/superset/register_duckdb.py").read())`
>
> Otherwise, configure the connection manually in the DuckDB UI.

- `meltano invoke superset:ui` (to launch the [Superset UI](http://127.0.0.1:8088/))

You are now free to explore the data yourself or have an overview look with the imported dashboard **Business & Customer Insights**.

---

## Future Improvements

- CI/CD workflows
- Orchestration ?
- Containerization
- Multiple deployments
- Improve Superset Dashboard with more in-depth charts and analysis
- Makefile

---
