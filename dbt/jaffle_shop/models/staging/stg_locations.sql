with

source as (

    select * from {{ source('jaffle_shop','raw_stores') }}

),

renamed as (

    select
        -- ids
        id as location_id,

        -- strings
        "name" as location_name,
        
        -- numerics
        tax_rate,

        -- timestamps
        opened_at

    from source

)

select * from renamed