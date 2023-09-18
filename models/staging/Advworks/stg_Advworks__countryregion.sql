with 

source as (

    select * from {{ source('Advworks', 'countryregion') }}

),

renamed as (

    select
         countryregioncode as country_region_code
        , name as country
        , cast(modifieddate as date) as updated_date 
    from source

)

select * from renamed
