{% snapshot item_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='item_number',
    strategy='timestamp',
    updated_at='date',
  )
}}

SELECT
    item_number,    -- Now the unique key
    item_description,
    category,
    category_name,
    vendor_number,
    vendor_name,
    pack,
    bottle_volume_ml,
    date  -- Timestamp for updates
FROM {{ source('iowa_liquor_sales', 'sales') }}


{% endsnapshot %}