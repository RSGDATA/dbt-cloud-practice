-- Reviews carry no surrogate key, so the natural key is the dedup grain.
with source as (
    select * from {{ source('airbnb', 'reviews') }}
)

select *
from source
qualify row_number() over (
    partition by listing_id, reviewer_name, date
    order by date desc
) = 1
