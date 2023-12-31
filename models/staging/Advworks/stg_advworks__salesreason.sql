with 

source as (

    select * from {{ source('data_source', 'salesreason') }}

),

renamed as (

    select
        salesreasonid as sales_reason_id
        , name as sale_reason
        , reasontype as sale_category
        , modifieddate as update_date
    from source

)

select * from renamed
