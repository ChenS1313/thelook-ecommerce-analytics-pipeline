with 

source as (

    select * from {{ source('thelook_ecommerce', 'orders') }}

),

renamed as (

    select
        cast(order_id as string) as order_id,
        cast(user_id as string) as user_id,
        status,
        gender,
        created_at,
        shipped_at,
        delivered_at,
        returned_at,
        num_of_item as num_of_items

    from source

)

select * from renamed