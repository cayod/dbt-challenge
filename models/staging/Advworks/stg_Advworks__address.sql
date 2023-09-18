with 

source as (

    select * from {{ source('Advworks', 'address') }}

),

, address as(    
    select
        addressid as address_id
        , city
        , stateprovinceid as state_province_id
        , cast(modifieddate as date) as updated_date 
    from source
)

select *
from address
