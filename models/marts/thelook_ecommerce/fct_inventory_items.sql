with inventory_items as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__inventory_items') }}
)



select
    -- Primary Key
    i.inventory_item_id,

    -- Foreign Keys
    i.product_id,
    i.distribution_center_id,

     -- Attributes
    i.department,
    i.category,
    i.brand,
    i.product_name,
    i.product_sku,

    -- Measures
    i.sale_price,
    i.cost,
    (i.sale_price - i.cost) as potential_profit,

    -- Timestamps
    i.arrived_at,
    i.sold_at,

    -- calculates days in inventory
    case 
        when i.sold_at is not null then timestamp_diff(i.sold_at, i.arrived_at, day)
        else timestamp_diff(current_timestamp(), i.arrived_at, day)
    end as days_in_inventory

from inventory_items i