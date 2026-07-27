with products as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__products') }}

)
,
distribution_centers as 
(
    select * 
    from {{ ref('stg_thelook_ecommerce__distribution_centers') }}
)
,

product_info as (
    select
        product_id,
        count(distinct order_item_id) as total_units_sold,
        sum(sale_price) as total_sales,
        sum(profit) as total_profit,
        count(distinct case when returned_at is not null then order_item_id end) as total_units_returned
    from {{ ref('int_thelook_ecommerce__order_items') }}
    group by 1
)



select
    -- Primary Key
    p.product_id,


    -- Attributes
    p.product_name,
    p.department,
    p.category,
    p.brand,
    p.product_sku,
    p.sale_price,
    p.cost,

    -- Metrics + nulls handling
    coalesce(pi.total_units_sold, 0) as total_units_sold,
    coalesce(pi.total_sales, 0) as total_sales,
    coalesce(pi.total_profit, 0) as total_profit,
    coalesce(pi.total_units_returned, 0) as total_units_returned,

 

    p.distribution_center_id,
    dc.city as distribution_center_city,
    dc.state_code as distribution_center_state_code,
    dc.longitude as distribution_center_longitude,
    dc.latitude as distribution_center_latitude

from products p
left join product_info pi
    on p.product_id = pi.product_id
left join distribution_centers dc 
    on p.distribution_center_id= dc.distribution_center_id