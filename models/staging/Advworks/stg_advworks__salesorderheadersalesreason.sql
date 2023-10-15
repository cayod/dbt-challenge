with 

source as (

    select * from {{ source('data_source', 'salesorderheadersalesreason') }}

),

renamed as (

    select
         salesorderid as sales_order_id
        , salesreasonid as sales_reason_id
        , modifieddate as update_date

    from source

)

select * from renamed
