with 

source as (

    select * from {{ source('advworks', 'person') }}

),

renamed as (

    select
        businessentityid as business_entity_id
        , persontype as person_type
        , firstname as first_name
        , middlename as middle_name
        , lastname as last_name
        , modifieddate as update_date

    from source

)

select * from renamed
