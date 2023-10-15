with 

source as (

    select * from {{ source('data_source', 'stateprovince') }}

),

renamed as (

    select
        stateprovinceid as state_province_id
        , territoryid as territory_id
        , countryregioncode as country_region_code
        , name as state
        , modifieddate as update_date

    from source

)

select * from renamed
