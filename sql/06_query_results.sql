-- =============================================================================
-- 06_query_results.sql
-- Queries DMF results after at least one scheduled run has completed.
-- Run this manually 10+ minutes after the pipeline completes, OR re-run the
-- pipeline and wait.
--
-- Three access methods are shown:
--   A) Flattened view   – easiest, recommended starting point
--   B) Raw event table  – full detail, good for custom dashboards
--   C) Table function   – single-table scope
-- =============================================================================

USE DATABASE dmf_demo;
USE SCHEMA raw;
USE WAREHOUSE dmf_wh;

-- ── A) Flattened view (recommended) ──────────────────────────────────────────
-- Shows all DMF results across every table you monitor.
SELECT *
FROM   SNOWFLAKE.LOCAL.DATA_QUALITY_MONITORING_RESULTS
ORDER BY result_ts DESC
LIMIT  50;

-- ── B) Raw event table ───────────────────────────────────────────────────────
-- Contains the unprocessed event payload; useful if you want to build
-- custom views or stream results elsewhere.
SELECT *
FROM   SNOWFLAKE.LOCAL.DATA_QUALITY_MONITORING_RESULTS_RAW
ORDER BY TIMESTAMP DESC
LIMIT  50;

-- ── C) Table function (single table at a time) ──────────────────────────────
-- Scope is limited to one table; handy for ad-hoc checks.
SELECT *
FROM   TABLE(SNOWFLAKE.CORE.DATA_QUALITY_MONITORING_RESULTS('dmf_demo.raw.customers'));
