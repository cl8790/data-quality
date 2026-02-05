-- =============================================================================
-- 01_setup.sql
-- Creates the database, schema, and warehouse for the DMF example.
-- NOTE: Requires Enterprise Edition. Select Enterprise when signing up for trial.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS dmf_demo;
USE DATABASE dmf_demo;

CREATE SCHEMA IF NOT EXISTS raw;
USE SCHEMA raw;

-- Use an XS warehouse to keep trial credits low
CREATE WAREHOUSE IF NOT EXISTS dmf_wh
  WITH WAREHOUSE_SIZE = 'XSMALL'
       AUTO_SUSPEND   = 60
       AUTO_RESUME    = TRUE;

USE WAREHOUSE dmf_wh;
