{{
    config(
        severity='error'
    )
}}

with order_unit_price_test as(
    select
        order_unit_price
        , order_quantity
        , (order_unit_price * order_quantity)order_total
        , order_year_date
    from {{ ref('fact_sales') }}
),

revenue_cte as (
    select sum(order_total) as revenue
    , order_year_date
    from order_unit_price_test
    where order_year_date = 2011
    group by order_year_date
)

select *
from revenue_cte
where revenue not between 12646111 and 12646113

