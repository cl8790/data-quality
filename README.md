# data-quality

# Snowflake Data Metric Functions (DMF) – End-to-End Demo

Deploys a complete DMF data-quality demo to Snowflake via GitHub Actions.

## What this demo covers

| DMF | Type | Measures |
|---|---|---|
| `NULL_COUNT` / `NULL_PERCENT` | System | Missing values in `first_name`, `email`, `age` |
| `DUPLICATE_COUNT` | System | Duplicate `customer_id` values |
| `ROW_COUNT` | System | Total rows in `customers` |
| `FRESHNESS` | System | Staleness based on `created_at` |
| `negative_age_count` | Custom | Rows where `age < 0` |
| `orphan_order_count` | Custom (cross-table) | Orders referencing a `customer_id` not in `customers` |

---

## Prerequisites

1. **Snowflake trial account – Enterprise Edition**
   - Sign up at <https://www.snowflake.com/free-trial/>
   - When prompted, select **Enterprise** as the edition. DMFs are an Enterprise-only feature.

2. **Key-pair authentication set up**
   - Generate a key pair:
     ```bash
     openssl genrsa -out private_key.pem 2048
     openssl rsa -in private_key.pem -pubout -out public_key.pem
     ```
   - Register the public key in Snowflake:
     ```sql
     ALTER USER <your_user> SET RSA_PUBLIC_KEY = '<base64-public-key-without-headers>';
     ```
   - Keep `private_key.pem` – you will upload it as a GitHub secret.

3. **GitHub repository**
   - Push this project to a GitHub repo (any name).

---

## GitHub Secrets

Go to **Settings → Secrets and variables → Actions** and add these four secrets:

| Secret name | Value |
|---|---|
| `SNOWFLAKE_ACCOUNT` | Your account identifier (e.g. `abc12345` or `org.account`) |
| `SNOWFLAKE_USER` | Your Snowflake username |
| `SNOWFLAKE_PRIVATE_KEY_PEM` | Contents of `private_key.pem` (paste the full PEM text) |
| `SNOWFLAKE_ROLE` | Role to use – `SYSADMIN` is fine for a trial |

---

## Running the pipeline

1. Push a commit to `main`, **or** go to **Actions → Deploy Snowflake DMF Demo → Run workflow**.
2. The pipeline runs six SQL scripts in order and then does a smoke-check by calling every DMF ad-hoc. You will see the values in the Actions log immediately.

---

## Viewing scheduled results

The DMFs are scheduled to run every **10 minutes**. After the first run completes, open Snowsight or run `sql/06_query_results.sql` manually. Three access methods are demonstrated:

| Method | Object |
|---|---|
| Flattened view (recommended) | `SNOWFLAKE.LOCAL.DATA_QUALITY_MONITORING_RESULTS` |
| Raw event table | `SNOWFLAKE.LOCAL.DATA_QUALITY_MONITORING_RESULTS_RAW` |
| Table function | `TABLE(SNOWFLAKE.CORE.DATA_QUALITY_MONITORING_RESULTS(...))` |

---

## Expected smoke-check values

These are the values you should see in the CI log after the smoke-check step:

| Metric | Expected value | Why |
|---|---|---|
| `NULL_COUNT(first_name)` | 1 | Row with `customer_id = 3` |
| `NULL_COUNT(email)` | 2 | Rows 4 and 6 |
| `NULL_COUNT(age)` | 2 | Rows 5 (also negative) and 6 |
| `NULL_PERCENT(email)` | ~18.18 | 2 of 11 rows |
| `DUPLICATE_COUNT(customer_id)` | 2 | Two rows with `customer_id = 1` |
| `ROW_COUNT` | 11 | 10 original + 1 duplicate insert |
| `negative_age_count` | 1 | Row with `age = -5` |
| `orphan_order_count` | 2 | Two orders with `customer_id = 999` |

---

## Cleaning up

Run in Snowsight to remove everything and avoid any ongoing credit usage:

```sql
DROP DATABASE IF EXISTS dmf_demo;
```
