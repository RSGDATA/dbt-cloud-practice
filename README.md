# dbt-cloud-practice

Sandbox for rehearsing the dbt Cloud workflow: build on a feature branch in the Studio IDE,
then promote `dev → test → prod` through pull requests.

## Layers

Each layer may only reach back one step. That rule is what makes the DAG readable.

| Layer | Reads from | Job | Materialized |
|---|---|---|---|
| `bronze/` | `source()` — the **only** layer allowed to | Land raw, dedup to latest as-of date | view |
| `silver/` | `ref()` on bronze | Rename, cast, clean | view |
| `gold/` | `ref()` on silver | Business models (dim / fct) | table |

## Layers × environments

The same code produces one set of schemas per environment. dbt prefixes each layer's
custom schema with the environment's schema:

| | bronze | silver | gold |
|---|---|---|---|
| **Development** | `DEV_bronze` | `DEV_silver` | `DEV_gold` |
| **Staging** | `TEST_bronze` | `TEST_silver` | `TEST_gold` |
| **Production** | `PROD_bronze` | `PROD_silver` | `PROD_gold` |

You never write a dev, test or prod version of a model. There is one model. The environment
decides where it lands.

## Branches

No `main`. Three long-lived branches, one per environment:

| Branch | Environment | Gets code via |
|---|---|---|
| `dev` | Development (the IDE) | PR from a `feature/*` branch |
| `test` | Staging | PR from `dev` |
| `prod` | Production | PR from `test` |

`dev` is the repo default, so feature PRs target it automatically. `test` and `prod` require
a pull request — no direct pushes.

## Commands

```bash
dbt build                       # everything
dbt build --select bronze       # one layer
dbt build --select +dim_listings # a model and all its upstreams
dbt build --select sl_listings+  # a model and all its downstreams
```

The dbt project is at the **repo root** — leave dbt Cloud's project subdirectory blank.
