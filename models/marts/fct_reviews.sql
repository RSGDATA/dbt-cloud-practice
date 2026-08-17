with reviews as (
    select * from {{ ref('stg_reviews') }}
)

select
    listing_id,
    review_date,
    reviewer_name,
    review_text,
    review_sentiment
from reviews
where review_text is not null
