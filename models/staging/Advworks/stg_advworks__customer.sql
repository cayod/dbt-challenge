with 

source as (

    select * from {{ source('advworks', 'customer') }}

),

renamed as (

    select
         customerid as customer_id
        , personid as person_id
        , territoryid as territory_id
        , storeid as store_id
        , modifieddate as updated_date 
    from source

)

select * from renamed
