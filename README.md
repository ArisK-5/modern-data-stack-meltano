(title)

(intro to the project, technologies used, skills demonstrated, etc)

(architecture diagram)

Environmet setup

- modify .env
- create an empty .duckdb file in /duckdb (duckdb jaffle_shop.duckdb)
- use uv to create the venv ( uv venv .venv && uv sync )
- use direnv to load .env in venv ( direnv allow and direnv reload when making changes in .env)

DuckDB

- duckdb jaffle_shop.duckdb (create the database file)
- duckdb jaffle_shop.duckdb --ui (opens duckdb ui)
- use .exit or .quit to exit the CLI.
- (Note on concurrency.)

Meltano

- meltano run tap-faker target-duckdb (data ingestion)
- meltano invoke dbt-duckdb:deps (install dbt packages)
- meltano invoke dbt-duckdb:build (data transformation)
- meltano run etl (full ETL job defined in meltano.yml)
- meltano run dbt_docs (creates dbt documentation and dag)

dbt project

- (note on following dbt best practices but also that sql model development can greatly vary from company to company)
- dbt is meant to add simplicity to complexity. Therefore, intermediate model would be obsolete with the simplicity of this dataset. Nonetheless, I tried to incorporate as many dbt features would make sense to use given the nature of the data and the possibility of its volume scaling.
- (?) testing is done at the source, where tables are smaller, resulting in a more efficient workflow.
- (picture of the dbt dag, command to generate it and documentation)

Superset

- meltano install (install all plugins, run with --clean for a fresh re-install)
- meltano invoke superset:initialize (initializes superset db, run with --force after first time)
- meltano invoke superset:create-admin (first time only)
- meltano invoke superset shell
  exec(open("analyze/superset/register_duckdb.py").read())

  or

  meltano invoke superset shell <<'EOF'
  exec(open("analyze/superset/register_duckdb.py").read())
  EOF

- meltano invoke superset:ui (to launch superset ui —> http://127.0.0.1:8088/)
- (create Datasets in Superset UI)
- (load the dashboard?)


- Metric ideas:
  Sales 
    - % of returned products 
    - % of unsuccessful orders 
    - cumulative revenue (split by year?) 
    - sales overtime (per month/year/etc) 
    - user with the most orders
  Users Analysis 
    - Cumulative amount of users / user growth (split by year?) 
    - Amount of users / uccupation 
    - Amount of users / gender 
    - Amount of users / nationality 
    - Amount of users / academic_degree 
    - Distribution of user height / weight / age
