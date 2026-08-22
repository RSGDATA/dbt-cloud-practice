-- Bronze: the ONLY layer allowed to call source().
-- Job: land the raw feed and keep one row per key -- the most recent as-of date.
-- No renaming, no casting, no business logic.

with source as (
    select * from {{ source('airbnb', 'listings') }}
)

select *
from source
qualify row_number() over (
    partition by id
    order by updated_at desc
) = 1
