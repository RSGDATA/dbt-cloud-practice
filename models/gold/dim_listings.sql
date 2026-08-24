-- Gold: references silver with ref(). Business-facing shapes.

with listings as (
    select * from {{ ref('sl_listings') }}
),

hosts as (
    select * from {{ ref('sl_hosts') }}
)

select
    listings.listing_id,
    listings.listing_name,
    listings.room_type,
    listings.minimum_nights,
    listings.price,
    listings.host_id,
    hosts.host_name,
    hosts.is_superhost,
    listings.created_at,
    listings.updated_at
from listings
left join hosts on listings.host_id = hosts.host_id
