# Optimization Report

## Outcome

This execution is marked **FAILED** in **DRY_RUN** mode.

## Why it failed

No executable DDL was provided. The supplied input consisted only of comments and did not contain a `CREATE OR REPLACE` statement.

## What to provide next time

Please supply the full `CREATE OR REPLACE VIEW ... AS` or `CREATE OR REPLACE PROCEDURE ...` DDL of the object to be optimized, including:

- Database and schema qualifiers (if available)
- Complete SELECT body (for views)
- Complete procedure body, language, and parameters (for procedures)

Once provided, the pipeline can generate:

- A validated optimized definition
- Schema + lineage diagrams
- Column lineage documentation
- (Procedures) procedure flow diagram
