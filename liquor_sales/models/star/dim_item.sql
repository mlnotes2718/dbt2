SELECT DISTINCT
    item_number,
    item_description,
    category,
    category_name,
    vendor_number,
    vendor_name,
    pack,
    bottle_volume_ml
FROM {{ source('iowa_liquor_sales', 'sales') }}


-- {{ source('iowa_liquor_sales', 'sales') }}
-- WHERE CURRENT_DATE > dbt_valid_from and dbt_valid_to IS NULL
-- FROM {{ ref('item_snapshot') }}