SELECT
    item_number,
    item_description,
    category,
    category_name,
    vendor_number,
    vendor_name,
    pack,
    bottle_volume_ml
FROM {{ ref('item_snapshot') }}