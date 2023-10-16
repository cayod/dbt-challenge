with customer_cte as (
    select
        customer_id
        , cast(person_id as string) as person_id
    from {{ ref('stg_advworks__customer') }}
    where person_id is not null
)

, person_cte as (
    select
        cast(business_entity_id as string) as business_entity_id
        , case
            when middle_name is null then concat(first_name, ' ', last_name)
            else concat(first_name, ' ', middle_name,'.', ' ', last_name)
        end as customer_name
    from {{ ref('stg_advworks__person') }}
)

, joined_tables as(
    select
        row_number() over (order by customer_id) as customer_sk
        , customer_cte.customer_id
        , person_cte.customer_name
    from customer_cte
    left join person_cte on customer_cte.person_id = person_cte.business_entity_id
)

select 
    cast(customer_sk as string) as customer_sk
    , customer_id
    , customer_name
from joined_tables