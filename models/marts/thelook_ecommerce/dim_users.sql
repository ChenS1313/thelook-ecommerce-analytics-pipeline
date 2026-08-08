with users as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__users') }}

),
user_orders_summary as 
(
    select
        user_id,
        customer_age_group,
        min(order_created_at) as first_order_date,
        max(order_created_at) as most_recent_order_date,
        count(distinct order_id) as total_orders,
        sum(sale_price) as lifetime_value,
        sum(profit) as total_profit
    from {{ ref('int_thelook_ecommerce__order_items') }}
    group by 1,2
)

select
    -- Primary Key
    u.user_id,

    -- Attributes
    u.first_name,
    u.last_name,
    u.age,
    uos.customer_age_group as user_age_group,
    u.gender,
    u.email,
    u.address,
    u.city,
    u.state,
    u.country,
    u.postal_code,
    u.latitude,
    u.longitude,
    u.traffic_source,

    -- User Metrics + nulls handling
    coalesce(uos.total_orders, 0) as total_orders,
    coalesce(uos.lifetime_value, 0) as lifetime_value,
    coalesce(uos.total_profit, 0) as total_profit,
    uos.first_order_date,
    uos.most_recent_order_date,

    -- Timestamps
    u.created_at as user_created_at

from users u
left join user_orders_summary uos
    on u.user_id = uos.user_id

