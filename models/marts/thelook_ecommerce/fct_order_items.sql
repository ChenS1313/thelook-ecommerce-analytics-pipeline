with order_items as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__order_items') }}
),
products as 
(
    select product_id,
           cost
    from {{ ref('stg_thelook_ecommerce__products') }}
),

orders as 
(
    select order_id,
           created_at as order_created_at,
    from {{ ref('stg_thelook_ecommerce__orders') }}

)


select  
    -- Primary Key
    oi.order_item_id,

    -- Foreign Keys
    oi.order_id,
    oi.user_id,
    oi.product_id,
    oi.inventory_item_id,

    -- Timestamps
    o.order_created_at,
    oi.item_created_at,
    oi.shipped_at,
    oi.delivered_at,
    oi.returned_at,

    -- Status
    oi.status,

    -- Financials
    oi.sale_price,
    p.cost,
    oi.sale_price - p.cost as profit
from order_items oi
left join orders o 
    on oi.order_id = o.order_id
left join products p 
on oi.product_id = p.product_id