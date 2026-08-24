with hosts as (
    select * from {{ ref('br_hosts') }}
)

select
    id                              as host_id,
    coalesce(name, 'N/A')           as host_name,
    is_superhost = 't'              as is_superhost,
    created_at,
    updated_at
from hosts
