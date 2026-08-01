with items as (
    select * 
    from {{ ref('int_thelook_ecommerce__order_items') }}
)

select
    -- Primary Key
    i.order_item_id,

    --Foreign Keys
    i.order_id,
    i.user_id,
    i.product_id,
    i.inventory_item_id,

    -- Timestamps
    i.order_created_at,
    i.item_created_at,
    i.shipped_at,
    i.delivered_at,
    i.returned_at,

    --Attributes
    customer_country,       
    category,     
    department,    
    brand,

    i.customer_age,
    i.customer_age_group,

    -- Item Financials
    i.status,
    i.sale_price,
    i.cost,
    i.profit,


from items i
