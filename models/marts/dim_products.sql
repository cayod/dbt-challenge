with products_cte as (
    select
        row_number() over (order by product_id) as product_sk
        , product_id
        , product_name
    from {{ ref('stg_advworks__product') }}
)

select *
from products_cte