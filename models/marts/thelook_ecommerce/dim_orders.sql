with orders as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__orders') }}
),

order_items_aggregated as 
(
    select
        order_id,
        user_country,
        sum(sale_price) as order_sales,
        sum(cost) as order_cost,
        sum(profit) as order_profit,
        sum(case when returned_at is not null then 1 else 0 end) as returned_items_count
    from {{ ref('int_thelook_ecommerce__order_items') }}
    group by order_id, user_country
)

select
    -- Primary Key
    o.order_id,

    -- Foreign Key
    o.user_id,

    -- Attributes
    o.status,
    o.gender,
    o.num_of_items,
    oia.user_country,

    -- Timestamps
    o.created_at,
    o.shipped_at,
    o.delivered_at,
    o.returned_at,

    -- Metrics  + nulls handling
    coalesce(oia.order_sales, 0) as order_sales,
    coalesce(oia.order_cost, 0) as order_cost,
    coalesce(oia.order_profit, 0) as order_profit,
    coalesce(oia.returned_items_count, 0) as returned_items_count,

    -- Operational metrics
    date_diff(o.shipped_at, o.created_at, day) as days_to_ship,
    date_diff(o.delivered_at, o.created_at, day) as days_to_deliver

from orders o
left join order_items_aggregated oia
    on o.order_id = oia.order_id