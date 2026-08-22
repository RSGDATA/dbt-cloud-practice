with source as (
    select * from {{ source('airbnb', 'hosts') }}
)

select *
from source
qualify row_number() over (
    partition by id
    order by updated_at desc
) = 1
