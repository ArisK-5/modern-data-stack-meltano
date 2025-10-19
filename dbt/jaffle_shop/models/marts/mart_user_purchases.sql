with

purchases as (

    select * from {{ ref('stg_purchases') }}

),

users as  (

    select * from {{ ref('stg_users') }}

),

purchases_and_users_joined as (

    select
        purchases.purchase_id,
        purchases.product_id,
        users.user_id,
        users.first_name,
        users.residence_state,
        purchases.is_successful_purchase,
        purchases.is_returned_purchase,
        purchases.purchased_at,
        purchases.returned_at

    from purchases

    left join users
        on purchases.user_id = users.user_id

)

select * from purchases_and_users_joined