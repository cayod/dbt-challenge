with address as(
    select
        address_sk
        , address_id
    from {{ ref('dim_address') }}
)

, credit_card as (
    select
        credit_card_sk
        , cast(credit_card_id as string) as credit_card_id
    from {{ ref('dim_credit_card') }}
)

, customers as (
    select
        customer_sk
        , customer_id
    from {{ ref('dim_customers') }}
)

, products as (
    select
        product_sk
        , product_id
    from {{ ref('dim_products') }}
)

, sales_reason as (
    select
        sales_reason_sk
        , cast(sales_order_id as string) as sales_order_id
    from {{ ref('dim_sales_reason') }}
)

, sales_order_detail_joined as (
    select
        cast(sales_order_id as string) as sales_order_id
        , order_quantity
        , order_unit_price
        , products.product_sk as product_fk
    from {{ ref('stg_advworks__sales_orderdetail') }} as sales_order_detail
    left join products on sales_order_detail.product_id = products.product_id
)

, sales_order_header_joined as (
    select
        sales_order_header.sales_order_id
        , customer_sk as customer_fk
        , address_sk as address_fk
        , credit_card_sk as credit_card_fk
        , sales_reason_sk as sales_reason_fk
        , sales_order_header.order_date
        , case
            when sales_order_header.order_month_date = 1 then 'January'
            when sales_order_header.order_month_date = 2 then 'February'
            when sales_order_header.order_month_date = 3 then 'March'
            when sales_order_header.order_month_date = 4 then 'April'
            when sales_order_header.order_month_date = 5 then 'May'
            when sales_order_header.order_month_date = 6 then 'June'
            when sales_order_header.order_month_date = 7 then 'July'
            when sales_order_header.order_month_date = 8 then 'August'
            when sales_order_header.order_month_date = 9 then 'September'
            when sales_order_header.order_month_date = 10 then 'October'
            when sales_order_header.order_month_date = 11 then 'November'
            when sales_order_header.order_month_date = 12 then 'December'
            else 'Missing Order Date'
        end as order_month_date
        , sales_order_header.order_year_date
        , case
            when order_status = 1 then 'In process'
            when order_status = 2 then 'Approved'
            when order_status = 3 then 'Backordered'
            when order_status = 4 then 'Rejected'
            when order_status = 5 then 'Shipped'
            else 'Cancelled'
        end as order_status
    from {{ ref('stg_advworks__salesorderheader') }} as sales_order_header
    left join customers on sales_order_header.customer_id = customers.customer_id
    left join address on sales_order_header.bill_to_address_id = address.address_id
    left join credit_card on sales_order_header.credit_card_id = credit_card.credit_card_id
    left join sales_reason on sales_order_header.sales_order_id = sales_reason.sales_order_id
)

, sales as (
    select
        row_number() over(order by sales_order_header.sales_order_id) as sales_sk
        , sales_order_header.sales_order_id
        , sales_order_header.customer_fk
        , sales_order_header.address_fk
        , sales_order_header.credit_card_fk
        , sales_order_header.sales_reason_fk
        , sales_order_detail.product_fk
        , sales_order_header.order_status
        , sales_order_detail.order_quantity
        , sales_order_detail.order_unit_price
        , sales_order_header.order_date
        , sales_order_header.order_month_date
        , sales_order_header.order_year_date
    from sales_order_header_joined as sales_order_header
    left join sales_order_detail_joined as sales_order_detail on sales_order_header.sales_order_id = sales_order_detail.sales_order_id
)

select *
from sales
