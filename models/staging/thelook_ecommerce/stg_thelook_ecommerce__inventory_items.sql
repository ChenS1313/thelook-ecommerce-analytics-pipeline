with 

source as (

    select * from {{ source('thelook_ecommerce', 'inventory_items') }}

),

renamed as (

    select
        cast(id as string) as inventory_item_id,
        cast(product_id as string) as product_id,
        cast(product_distribution_center_id as string) as distribution_center_id,
        product_department as department,
        product_category as category,
        product_brand as brand,
        product_name,
        product_sku,
        created_at as arrived_at,
        sold_at,
        round(cast(product_retail_price as numeric),2) as retail_price,
        round(cast(cost as numeric),2) as cost
        
        

    from source

)

select * from renamed