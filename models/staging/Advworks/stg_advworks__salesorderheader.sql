with 

source as (

    select * from {{ source('advworks', 'salesorderheader') }}

),

renamed as (

    select
        cast(salesorderid as string) as sales_order_id
        , cast(orderdate as date) as order_date
        , extract(month from orderdate) as order_month_date
        , extract(year from orderdate) as order_year_date
        , cast(duedate as date) as order_due_date
        , cast(shipdate as date) as order_ship_date
        , status as order_status
        , customerid as customer_id
        , territoryid as territory_id
        , cast(creditcardid as string) as credit_card_id
        , cast(billtoaddressid as string) as bill_to_address_id
        , subtotal as order_subtotal
        , taxamt as order_tax_amount
        , freight as order_freight
        , totaldue as order_income
        , modifieddate as update_date 

    from source

)

select * from renamed
