with 

source as (

    select * from {{ source('thelook_ecommerce', 'users') }}

),

renamed as (

    select
        cast(id as string) as user_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        age,
        gender,
        trim(email) as email,
        trim(street_address) as address ,
        coalesce(NULLIF(TRIM(city), 'null'), 'Unknown') as city,
        trim(state) as state,
        case -- Standardizes country names
            when trim(country) ='España' then 'Spain'
            when trim(country) ='Deutschland' then 'Germany'
            else trim(country)
        end as country,
        postal_code,
        latitude,
        longitude,
        traffic_source,
        created_at

    from source

)

select * from renamed