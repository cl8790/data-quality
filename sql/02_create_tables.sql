-- =============================================================================
-- 02_create_tables.sql
-- Creates two tables:
--   CUSTOMERS  – main fact-style table (will have quality issues by design)
--   ORDERS     – used by the custom cross-table DMF
-- =============================================================================

USE DATABASE dmf_demo;
USE SCHEMA raw;
USE WAREHOUSE dmf_wh;

CREATE OR REPLACE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    email         VARCHAR(200),
    age           NUMBER,
    created_at    TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE orders (
    order_id      NUMBER PRIMARY KEY,
    customer_id   NUMBER,          -- FK to customers – intentionally has orphans
    product       VARCHAR(100),
    amount        NUMBER(10,2),
    order_date    DATE
);
