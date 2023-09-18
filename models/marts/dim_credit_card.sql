with sales_credit_card_cte as(
    select
        row_number() over (order by credit_card_id) as credit_card_sk
        , credit_card_id
        , credit_card_type
    from {{ ref('stg_advworks__creditcard') }}
)

select *
from sales_credit_card_cte