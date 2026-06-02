# SQL Server Reverse Engineering with Metadata

This repository contains the SQL scripts used in the video about **reverse engineering a SQL Server database using system metadata**.

The goal is simple:

> understand an undocumented database without relying on guesswork.

Instead of manually browsing hundreds of tables, these scripts use SQL Server catalog views to:

- audit the database structure
- identify key tables
- inspect PK / FK quality
- reconstruct relationships
- generate graph-like views of the model
- prepare metadata for AI-assisted documentation

---

## What this repository is for

These scripts are useful when you need to:

- explore an unknown SQL Server database
- understand a legacy schema
- prepare a migration
- onboard onto an existing platform
- document a model with little or no functional documentation

This is not a “full modeling framework”.
It is a **practical reverse engineering toolkit** built for real-world database analysis.

---

## Requirements

- SQL Server 2017+ recommended
- SSMS or any SQL editor that can run T-SQL
- Access to system catalog views (`sys.tables`, `sys.columns`, `sys.foreign_keys`, etc.)

> Some scripts are especially relevant on newer SQL Server versions when working with ordered aggregations and larger metadata workloads.

---

## Repository structure

### 1. Environment / prerequisites
- **`versionning_database.sql`**  
  Checks SQL Server version and database compatibility level before running the rest of the analysis.

---

### 2. Basic audit
- **`basic_counts_tvc.sql`**  
  Returns high-level counts for:
  - tables
  - views
  - columns

- **`wide_tables.sql`**  
  Identifies the tables with the highest number of columns.

- **`big_tables.sql`**  
  Estimates the largest tables by row count.

- **`pk_fk_count_quality.sql`**  
  Checks:
  - number of primary keys
  - number of foreign keys
  - foreign keys that are disabled or not trusted

- **`connected_tables.sql`**  
  Highlights the most connected tables in the schema using FK in/out degrees.

- **`fact_dim_ref_heuristic_guess.sql`**  
  Provides a first-pass heuristic guess of table roles:
  - FACT
  - DIMENSION / REFERENCE
  - UNKNOWN / MIXED

> This script is heuristic only. It is designed to guide exploration, not to produce a definitive data model.

---

### 3. Model reconstruction
- **`nodes.sql`**  
  Extracts tables and their primary key columns.

- **`edges.sql`**  
  Reconstructs exact FK-based relationships between tables, including join conditions.

- **`tree.sql`**  
  Builds a recursive hierarchical view of table relationships.

- **`paths.sql`**  
  Reconstructs deeper relationship paths across the model.

---

### 4. AI-ready metadata
- **`data_dict_json.sql`**  
  Exports structural metadata as JSON for AI-assisted data dictionary generation.

This can be used with tools such as Copilot or ChatGPT to generate:
- table summaries
- column descriptions
- onboarding notes
- executive-friendly model summaries

---

## Recommended execution order

If you want to follow the same exploration flow as in the video, run the scripts in this order:

1. `versionning_database.sql`
2. `basic_counts_tvc.sql`
3. `wide_tables.sql`
4. `big_tables.sql`
5. `pk_fk_count_quality.sql`
6. `connected_tables.sql`
7. `fact_dim_ref_heuristic_guess.sql`
8. `nodes.sql`
9. `data_dict_json.sql`
10. `edges.sql`
11. `tree.sql`
12. `paths.sql`

---

## Analysis logic

The workflow follows four progressive steps:

### 1. Audit the terrain
Before trying to understand relationships, start by measuring the perimeter:
- how many tables?
- how many views?
- how many columns?
- which objects are biggest / widest?

### 2. Assess model quality
Not every schema is equally trustworthy.
The scripts inspect PK / FK structure and detect:
- weak relational quality
- disabled constraints
- not trusted foreign keys

### 3. Reconstruct the graph
Tables become **nodes**.  
Foreign keys become **edges**.  
From there, recursive traversal helps reveal:
- hubs
- chains
- hierarchy
- likely subject areas

### 4. Generate documentation
Once metadata is extracted, it can be reused to generate:
- a data dictionary
- a model summary
- a first-pass onboarding document

---

## Notes

- All scripts are **read-only** and intended for exploration.
- No schema objects are created or modified.
- Row counts may be approximate depending on the script and SQL Server metadata source.
- Relationship interpretation depends on the quality of the underlying constraints.
- Archive / history tables may naturally appear as weakly connected or isolated.

---

## Typical use cases

This repository can help with:

- legacy database discovery
- technical due diligence
- migration planning
- metadata-driven documentation
- model onboarding
- SQL Server reverse engineering demos and workshops

---

## Video context

These queries were used as the technical foundation for a walkthrough showing how to reverse engineer a SQL Server database from metadata, step by step, including an optional AI-assisted summary phase.

---

## Disclaimer

The FACT / DIM / REF classification is heuristic and should be treated as a starting point for analysis, not as a final semantic model.

AI-generated summaries based on exported metadata should also be reviewed before being used as documentation.

---

## Author

**Bruno SQL**  
Practical SQL, data troubleshooting, and real-world reverse engineering.

If this repository is useful, feel free to reuse, adapt, and build on top of it.
``
