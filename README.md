# dbt-cloud-practice

A sandbox dbt project for rehearsing the dbt Cloud workflow: build a model on a feature
branch in the Cloud IDE, then promote it `dev → test → prod` through pull requests.

Reads the same raw data as the Bootcamp course (`AIRBNB.RAW`), but is deliberately kept
separate so practice merges never touch coursework history.

## Branches

There is no `main`. Three long-lived branches, one per environment:

| Branch | dbt Cloud environment | Snowflake schema | How code gets here |
|---|---|---|---|
| `dev`  | Development (the IDE) | `DEV`  | PR from a `feature/*` branch |
| `test` | Staging (deployment)  | `TEST` | PR from `dev` |
| `prod` | Production (deployment) | `PROD` | PR from `test` |

`dev` is the repo default branch, so a PR opened from a feature branch targets it
automatically. `test` and `prod` require a pull request to merge — no direct pushes.

## The promotion loop

```
feature/my-model ──► dev ──► test ──► prod
     (Cloud IDE)      (PR)    (PR)     (PR)
```

1. In the Cloud IDE, check out `dev`, then **Create branch** → `feature/my-model`.
2. Write the model. Use **Preview** to see rows, **Compile** to see the rendered SQL.
3. Run it: `dbt run --select my_model`, then `dbt test --select my_model`.
4. **Commit and sync** → commits and pushes the branch.
5. **Create pull request** → opens GitHub with base `dev`. Review the diff, merge.
6. Back in the IDE, check out `dev` and **Pull from remote**.
7. Promote: open a PR `dev → test`, merge, watch the Staging job build into `TEST`.
8. Promote again: PR `test → prod`, merge, watch the Production job build into `PROD`.

The thing worth internalising: a deployment environment is **pinned to one branch** via its
*custom branch* setting. That pin is the entire reason merging into `test` changes what the
Staging job builds. The code is identical at each tier — only the target schema differs.

## Layout

```
dbt_project.yml          project config, materialization defaults
models/
  sources.yml            points at AIRBNB.RAW (same in every environment)
  staging/               views: rename and lightly clean raw columns
    stg_listings.sql
    stg_hosts.sql
    stg_reviews.sql
  marts/                 tables: business-facing models
    dim_listings.sql
    fct_reviews.sql
```

The dbt project lives at the **repo root**, so the dbt Cloud project subdirectory setting
should be left **blank**.

## Useful commands in the IDE command bar

```bash
dbt debug                        # confirm the warehouse connection
dbt build                        # run + test everything
dbt run  --select stg_listings   # one model
dbt build --select +dim_listings # a model and everything it depends on
dbt test --select dim_listings
```
