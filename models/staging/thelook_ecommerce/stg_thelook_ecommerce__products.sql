with 

source as (

    select * from {{ source('thelook_ecommerce', 'products') }}

),

renamed as (

    select
        cast(id as string) as product_id,
        cast(distribution_center_id as string) as distribution_center_id,
        -- replaces null product names to their id's
        coalesce(nullif(name, ''),concat('Product ID: ', cast(id as string))) as product_name,
        department,
        category,
        brand,
        sku as product_sku,
        round(cast(cost as numeric),2) as cost,
        round(cast(retail_price as numeric),2)as sale_price
        

    from source

)

select * from renamed