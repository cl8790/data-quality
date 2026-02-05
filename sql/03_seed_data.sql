-- =============================================================================
-- 03_seed_data.sql
-- Seeds both tables with a mix of good and bad data so the DMFs have
-- something interesting to flag.
--
-- Intentional quality issues planted:
--   - NULLs in email and first_name
--   - Duplicate customer_id 101
--   - Negative age
--   - Orphan orders (customer_id 999 does not exist in customers)
-- =============================================================================

USE DATABASE dmf_demo;
USE SCHEMA raw;
USE WAREHOUSE dmf_wh;

-- ── Customers ────────────────────────────────────────────────────────────────
INSERT INTO customers (customer_id, first_name, last_name, email, age)
VALUES
    (1,   'Alice',   'Smith',    'alice@example.com',  28),
    (2,   'Bob',     'Jones',    'bob@example.com',    35),
    (3,   NULL,      'Williams', 'carol@example.com',  42),   -- NULL first_name
    (4,   'Diana',   'Brown',    NULL,                 31),   -- NULL email
    (5,   'Eve',     'Davis',    'eve@example.com',    -5),   -- negative age
    (6,   'Frank',   'Miller',   NULL,                 NULL), -- NULL email + age
    (7,   'Grace',   'Wilson',   'grace@example.com',  50),
    (8,   'Hank',    'Moore',    'hank@example.com',   45),
    (9,   'Ivy',     'Taylor',   'ivy@example.com',    33),
    (10,  'Jack',    'Anderson', 'jack@example.com',   27);

-- Duplicate customer_id 1 (first_name differs – easy to spot)
INSERT INTO customers (customer_id, first_name, last_name, email, age)
VALUES
    (1,   'AliceDUP', 'Smith', 'alice_dup@example.com', 28);

-- ── Orders ───────────────────────────────────────────────────────────────────
INSERT INTO orders (order_id, customer_id, product, amount, order_date)
VALUES
    (101, 1,   'Widget',   29.99, '2024-01-15'),
    (102, 2,   'Gadget',   49.99, '2024-01-16'),
    (103, 3,   'Doohickey', 9.99, '2024-02-01'),
    (104, 5,   'Widget',   29.99, '2024-02-10'),
    (105, 999, 'Gadget',   19.99, '2024-03-01'),  -- orphan: customer 999 missing
    (106, 999, 'Widget',   39.99, '2024-03-05');  -- orphan: customer 999 missing
