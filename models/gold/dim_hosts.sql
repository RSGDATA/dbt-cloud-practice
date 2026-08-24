with hosts as (
    select * from {{ ref('sl_hosts') }}
)

select
    host_id,
    host_name,
    is_superhost,
    created_at,
    updated_at
from hosts
