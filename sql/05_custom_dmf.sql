-- =============================================================================
-- 05_custom_dmf.sql
-- Defines and attaches two custom DMFs:
--
--   1. NEGATIVE_AGE_COUNT
--        Counts rows where age < 0.  Simple single-table validation.
--
--   2. ORPHAN_ORDER_COUNT
--        Cross-table DMF: counts orders whose customer_id does not exist
--        in the customers table.  Demonstrates multi-table DMFs (GA Jan 2025).
-- =============================================================================

USE DATABASE dmf_demo;
USE SCHEMA raw;
USE WAREHOUSE dmf_wh;

-- ── 1. Single-table custom DMF: negative ages ────────────────────────────────
CREATE OR REPLACE DATA METRIC FUNCTION dmf_demo.raw.negative_age_count(
    arg_t TABLE(age NUMBER)
)
RETURNS NUMBER
AS
$$
    SELECT COUNT(*) FROM arg_t WHERE age < 0
$$;

ALTER TABLE customers
    ADD DATA METRIC FUNCTION dmf_demo.raw.negative_age_count ON (age);

-- ── 2. Cross-table custom DMF: orphan orders ─────────────────────────────────
-- The first TABLE argument is the table the DMF is attached to (orders).
-- The second TABLE argument is passed explicitly when attaching (customers).
CREATE OR REPLACE DATA METRIC FUNCTION dmf_demo.raw.orphan_order_count(
    arg_orders   TABLE(customer_id NUMBER),
    arg_customers TABLE(customer_id NUMBER)
)
RETURNS NUMBER
AS
$$
    SELECT COUNT(*)
    FROM   arg_orders o
    WHERE  o.customer_id NOT IN (
               SELECT c.customer_id FROM arg_customers c
           )
$$;

ALTER TABLE orders
    ADD DATA METRIC FUNCTION dmf_demo.raw.orphan_order_count
        ON (customer_id)
        REFERENCING (dmf_demo.raw.customers(customer_id));

-- Schedule orders table DMFs on the same 10-min cadence
ALTER TABLE orders
    SET DATA_METRIC_SCHEDULE = '10 MINUTE';
