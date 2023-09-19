with products_cte as (
    select
        row_number() over (order by product_id) as product_sk
        , cast(product_id as string) as product_id
        , product_name
    from {{ ref('stg_advworks__product') }}
)

select cast(product_sk as string) as product_sk
    , product_id
    , product_name
from products_cte