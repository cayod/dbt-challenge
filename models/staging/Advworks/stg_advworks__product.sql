with 

source as (

    select * from {{ source('advworks', 'product') }}

),

products as(
    select
        productid as product_id
        , name as product_name
        , standardcost as product_std_cost
        , listprice as product_list_price
        , sellstartdate as product_sell_start_date
        , sellenddate as product_sell_end_date
        , modifieddate as update_date
    from source
)

select *
from products