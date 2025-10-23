from pathlib import Path

from diagrams import Cluster, Diagram
from diagrams.custom import Custom
from diagrams.onprem.analytics import Dbt, Superset
from diagrams.onprem.vcs import Git

ROOT_DIR = Path(__file__).resolve().parent.parent
ICONS_DIR = ROOT_DIR / "assets" / "icons"

with Diagram(
    name="Modern Data Stack (Local Development)",
    filename="assets/images/architecture",
    show=False,
    direction="LR",
):
    with Cluster("Developer Environment"):
        dev = Custom("Dev", str(ICONS_DIR / "dev.jpg"))
        git = Git("Git (Version Control)")

    with Cluster("Meltano"):
        meltano = Custom("JafGen Extractor (EL)", str(ICONS_DIR / "meltano.png"))
        duckdb = Custom("DuckDB (Data Warehouse)", str(ICONS_DIR / "duckdb.png"))
        dbt = Dbt("dbt (Transform)")
        superset = Superset("Superset (BI)")

    dev >> git
    dev >> meltano >> duckdb >> dbt >> duckdb >> superset
