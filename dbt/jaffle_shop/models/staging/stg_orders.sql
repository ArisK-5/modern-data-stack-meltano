with

source as (

    select * from {{ source('jaffle_shop','raw_orders') }}

),

renamed as (

    select
        -- ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,

        -- numerics
        (order_total / 100.0)::float as order_total,
        (subtotal / 100.0)::float as order_subtotal,
        (tax_paid / 100.0)::float as tax_paid,

        -- timestamps
        ordered_at

    from source

)

select * from renamed