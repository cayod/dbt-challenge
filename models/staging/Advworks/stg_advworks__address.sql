with 

source as (

    select * from {{ source('data_source', 'address') }}

),

 address as(    
    select
        addressid as address_id
        , city
        , stateprovinceid as state_province_id
        , modifieddate as updated_date 
    from source
)

select *
from address
