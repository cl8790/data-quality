-- =============================================================================
-- 04_attach_dmfs.sql
-- Attaches Snowflake system DMFs to the CUSTOMERS table and sets a schedule.
--
-- System DMFs used:
--   NULL_COUNT      – counts NULLs per column
--   NULL_PERCENT    – percentage of NULLs per column
--   DUPLICATE_COUNT – counts duplicate rows per column
--   ROW_COUNT       – total rows in table
--   FRESHNESS       – staleness based on created_at timestamp
-- =============================================================================

USE DATABASE dmf_demo;
USE SCHEMA raw;
USE WAREHOUSE dmf_wh;

-- ── Attach system DMFs ───────────────────────────────────────────────────────
ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.NULL_COUNT      ON (first_name);

ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.NULL_COUNT      ON (email);

ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.NULL_COUNT      ON (age);

ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.NULL_PERCENT    ON (email);

ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.DUPLICATE_COUNT ON (customer_id);

ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.ROW_COUNT       ON (customer_id);

ALTER TABLE customers
    ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.FRESHNESS       ON (created_at);

-- ── Schedule: run every 10 minutes ───────────────────────────────────────────
-- (10 min is the smallest practical interval for a demo; lower credit burn than
--  TRIGGER_ON_CHANGES if you keep re-inserting test rows.)
ALTER TABLE customers
    SET DATA_METRIC_SCHEDULE = '10 MINUTE';
