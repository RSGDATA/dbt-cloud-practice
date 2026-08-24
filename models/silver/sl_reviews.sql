with reviews as (
    select * from {{ ref('br_reviews') }}
)

select
    listing_id,
    date            as review_date,
    reviewer_name,
    comments        as review_text,
    sentiment       as review_sentiment
from reviews
where comments is not null
