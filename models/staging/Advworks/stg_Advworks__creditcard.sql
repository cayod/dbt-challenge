with 

source as (

    select * from {{ source('Advworks', 'creditcard') }}

),

renamed as (

    select
         creditcardid as credit_card_id
        , cardtype as credit_card_type
        , modifieddate as updated_date
    from source

)

select * from renamed
