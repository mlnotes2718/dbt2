# Lesson

## Brief

### Preparation

Create the conda environment based on the `environment.yml` file. We will also be using google cloud (for which the account was created in the previous unit) in this lesson.

### Lesson Overview

This lesson introduces data warehouse, ingestion model and dimensional modeling. It also contains hands-on _Transform_ part of ELT (dimensional modeling) with `dbt` and `BigQuery`.

---

## Part 1 - Data Warehouse and Dimensional Modeling

Conceptual knowledge, refer to slides.

---

## Part 2 - Hands-on with dbt and BigQuery

### Designing and Implementing Star Schema for Bicycle Hires Data

We will be using the `London Bicycle Hires` dataset. This data contains the number of hires of London's Santander Cycle Hire Scheme from 2011 to present. Data includes start and stop timestamps, station names and ride duration.

It is available at [BigQuery Public](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=london_bicycles&page=dataset).

We will create a dbt project from scratch and implement a star schema for the data warehouse.

> 1. Run `dbt init london_bicycle` to create a new dbt project.
> 2. Add a fact and dimension model.
> 3. Add tests.

### Designing and Implementing Star Schema and Snowflake Schema for Liquor Sales Data

In this section, we will be using the `liquor_sales` dataset. This dataset contains liquor sales data from Iowa, and available at [BigQuery Public](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=iowa_liquor_sales&page=dataset). The dbt project is located at `liquor_sales` directory. Skim through the `.yml` and `.sql` files in the `snapshots` and `models` directory.

The source is defined and configured in `models/sources.yml`. It refers to the `bigquery-public-data.iowa_liquor_sales.sales` table.

A star schema with a `sales` fact table, a `store` dimension table and an incomplete `item` dimension table have been implemented. The `schema.yml` files define the schemas for the fact and dimension tables. They contain the name, description and tests for the primary keys of the tables.

#### Snapshots

A snapshot is a table that contains the current state of a source table. Snapshots enable "looking back in time" at previous data states in their mutable tables. While some source data systems are built in a way that makes accessing historical data possible, this is not always the case. Snapshots implement _type-2 Slowly Changing Dimensions_ over mutable source tables. These Slowly Changing Dimensions (or SCDs) identify how a row in a table changes over time.

There is a snapshot for the `store` dimension table defined in `snapshots/store_snapshot.sql`.

#### Models

The `fact_sales` model is defined in `models/fact_sales.sql`. It is a view that selects from the source table.

The dimension models are nested in a `star` subdirectory. Refer to the `dbt_project.yml` file for the configuration. It uses a custom schema and materialized table.

The `dim_store` model is defined in `dim_store.sql`. It selects from the `store_snapshot` table. The `dim_item` model is defined in `dim_item.sql`. Currently it selects from the source table directly.

Build the models with the following command:

```bash
dbt run
```

#### Tests

Tests are defined in `schema.yml` files. They are used to validate the data in the tables. For example, the `dim_store` table has a test that checks if the `store_number` is unique and not null.

Run the tests with the following command:

```bash
dbt test
```

Observe the test results. There should be 1 failing test for the `dim_item` table.

#### Practice

> 1. Implement a snapshot for the `item` dimension table. Then update the `dim_item` model to use the snapshot.
> 2. Add a test for the `item_number` foreign key in the `fact_sales` table. The test should check if the `item_number` exists in the `dim_item` table.
> 3. Run the tests again and make sure they pass.

#### Snowflake Schema

In a snowflake schema, each dimension can have one or more dimensions. For example, the `item` dimension table can be further normalized into `item`, `category` and `vendor` dimension tables. The `item` dimension table will contain the `category` and `vendor_number` as foreign keys.

For the practices below, create a subdirectory under `models` called `snowflake`.

> 1. Normalize `dim_item` table into `dim_item`, `dim_category` and `dim_vendor` dimension tables.
> 2. Normalize `dim_store` table into `dim_store` and `dim_county` dimension tables.
> 3. Add `schema.yml` with tests for the primary and foreign keys.
> 4. Add a new custom `snowflake` schema with materialized tables in `dbt_project.yml`.
> 5. Run the dbt commands to build the models and run the tests.
