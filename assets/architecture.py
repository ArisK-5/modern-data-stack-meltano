from pathlib import Path

from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.onprem.analytics import Dbt, Superset
from diagrams.onprem.vcs import Git, Github

# Project directories
ROOT_DIR = Path(__file__).resolve().parent.parent
ICONS_DIR = ROOT_DIR / "assets/icons"
DIAGRAMS_DIR = ROOT_DIR / "assets/diagrams"

with Diagram(
    "Modern Data Stack\n(detailed architecture)",
    filename=str(DIAGRAMS_DIR / "architecture"),
    show=False,
    direction="LR",
):
    # Developer environment
    dev = Custom("Developer\n(uv environment)", str(ICONS_DIR / "dev.jpg"))
    git = Git("Git\n(Version Control)")
    github = Github("GitHub\n(Repository Hosting)")

    dev >> Edge(label="Develop") >> git  # Developer pushes to version control

    (
        git >> Edge(label="Pull") >> github >> Edge(label="Push") >> git
    )  # Version control interaction with GitHub

    # DuckDB warehouse
    duckdb = Custom("DuckDB\n(Data Warehouse)", str(ICONS_DIR / "duckdb.png"))

    # Meltano cluster
    with Cluster("Meltano\n(DataOps)"):
        # Extractor
        jafgen = Custom(
            "JafGen Extractor\n(Data Ingestion)", str(ICONS_DIR / "meltano.png")
        )

        # dbt transformations
        dbt = Dbt("dbt\n(Data Modeling)")

        # Superset BI
        superset = Superset("Superset\n(Business Intelligence)")

        # Edges inside the cluster
        jafgen >> Edge(label="Extract / Load") >> duckdb
        duckdb >> Edge(label="Transform") >> dbt >> duckdb
        superset >> Edge(label="Read") >> duckdb

    # Developer interaction with the project (Meltano cluster) through git
    jafgen - git
