with listings as (
    select * from {{ ref('stg_listings') }}
),

hosts as (
    select * from {{ ref('stg_hosts') }}
)

select
    listings.listing_id,
    listings.listing_name,
    listings.room_type,

    -- a 0-night minimum is a data error; treat it as 1
    case
        when listings.minimum_nights = 0 then 1
        else listings.minimum_nights
    end as minimum_nights,

    -- raw price arrives as a string like '$155.00'
    replace(listings.price_str, '$', '')::number(10, 2) as price,

    listings.host_id,
    coalesce(hosts.host_name, 'N/A') as host_name,
    hosts.is_superhost,
    listings.created_at,
    listings.updated_at

from listings
left join hosts on listings.host_id = hosts.host_id
