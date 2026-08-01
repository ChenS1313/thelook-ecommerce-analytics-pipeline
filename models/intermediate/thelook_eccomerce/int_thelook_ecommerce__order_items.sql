with order_items as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__order_items') }}
),

products as 
(
    select 
        product_id,
        cost,
        category,
        department,
        brand
    from {{ ref('stg_thelook_ecommerce__products') }}
),

orders as 
(
    select 
        order_id,
        created_at as order_created_at
    from {{ ref('stg_thelook_ecommerce__orders') }}
),

users as 
(
    select 
        user_id,
        country,
        age
    from {{ ref('stg_thelook_ecommerce__users') }}
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

    -- Attributes
    u.country as customer_country,
    u.age as customer_age,
    CASE 
        WHEN u.age < 18 THEN '<18'
        WHEN u.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 49 THEN '35-49'
        WHEN u.age >= 50 THEN '50+'
        ELSE 'Unknown'
    END AS customer_age_group,
    oi.status,
    p.category,
    p.department,
    p.brand,
    oi.sale_price,
    p.cost,
    (oi.sale_price - p.cost) as profit

from order_items oi
left join orders o 
    on oi.order_id = o.order_id
left join users u 
    on oi.user_id = u.user_id
left join products p 
    on oi.product_id = p.product_id