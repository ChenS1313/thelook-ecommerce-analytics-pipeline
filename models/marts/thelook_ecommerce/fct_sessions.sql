with events as (
    select * 
    from {{ ref('stg_thelook_ecommerce__events') }}
)

select
    -- Primary Key
    session_id,

    -- Foreign Key
    user_id,

    -- Attributes 
    any_value(traffic_source) as traffic_source,
    any_value(browser) as browser,

    -- Timestamps
    min(created_at) as session_started_at,
    max(created_at) as session_ended_at,

    -- Duration
    timestamp_diff(max(created_at), min(created_at), minute) as session_duration_minutes,

    -- Event Counts 
    count(event_id) as total_events,
    countif(event_type = 'home') as home_events_count,
    countif(event_type = 'department') as department_events_count,
    countif(event_type = 'product') as product_events_count,
    countif(event_type = 'cart') as cart_events_count,
    countif(event_type = 'purchase') as purchase_events_count,
    countif(event_type = 'cancel') as cancel_events_count

from events
group by 1, 2