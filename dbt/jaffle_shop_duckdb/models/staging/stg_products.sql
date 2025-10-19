with

source as (

    select * from {{ source('faker','products') }}

),

renamed as (

    select
        -- ids
        id as product_id,

        -- strings
    	make as brand,
	    model,

        -- numerics
        year::int as release_year,
	    price::numeric as price_euros,

        -- timestamps
        created_at::timestamp as created_at,
	    updated_at::timestamp as updated_at

    from source

)

select * from renamed