with

source as (

    select * from {{ source('faker','purchases') }}

),

renamed as (

    select
        -- ids
        id as purchase_id,
        user_id,
        product_id,

        -- booleans
        case
            when purchased_at is not null then true
            else false
        end as is_successful_purchase,
        case
            when returned_at is not null then true
            else false
        end as is_returned_purchase,

        -- timestamps
        added_to_cart_at::timestamp as added_to_cart_at,
        created_at::timestamp as created_at,
        purchased_at::timestamp as purchased_at,
        returned_at::timestamp as returned_at,
        updated_at::timestamp as updated_at
        
    from source

)

select * from renamed