with 

source as (

    select * from {{ source('thelook_ecommerce', 'distribution_centers') }}

),

renamed as (

    select
        cast(id as string) as distribution_center_id,
        LEFT(name,INSTR(name, ' ', -1)) as city,
        SUBSTR(name, INSTR(name, ' ', -1) + 1) as state_code,
        latitude,
        longitude

    from source

)

select * from renamed