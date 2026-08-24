-- Silver: references bronze with ref(). Never source().
-- Job: rename to business names, cast to real types, clean bad values.

with listings as (
    select * from {{ ref('br_listings') }}
)

select
    id                                          as listing_id,
    listing_url,
    name                                        as listing_name,
    room_type,

    -- a 0-night minimum is a data error; floor it at 1
    case when minimum_nights = 0 then 1 else minimum_nights end as minimum_nights,

    -- raw price arrives as a string like '$155.00'
    replace(price, '$', '')::number(10, 2)      as price,

    host_id,
    created_at,
    updated_at
from listings
