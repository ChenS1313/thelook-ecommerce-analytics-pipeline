with 

source as (

    select * from {{ source('thelook_ecommerce', 'order_items') }}

),

renamed as (

    select
        cast(id as string) as order_item_id,
        cast(order_id as string) as order_id,
        cast(user_id as string) as user_id,
        cast(product_id as string) as product_id,
        cast(inventory_item_id as string) as inventory_item_id,
        status,
        created_at,
        shipped_at,
        delivered_at,
        returned_at,
        round(cast(sale_price as numeric),2) as sale_price

    from source

)

select * from renamed