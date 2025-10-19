with

purchases as (

    select * from {{ ref('stg_purchases') }}

),

products as  (

    select * from {{ ref('stg_products') }}

),

purchases_and_products_joined as (

    select
        purchases.purchase_id,
        purchases.user_id,
        purchases.product_id,
        products.brand,
        products.model,
        products.price_euros,
        purchases.is_successful_purchase,
        purchases.is_returned_purchase,
        purchases.added_to_cart_at,
        purchases.created_at,
        purchases.purchased_at,
        purchases.returned_at,
        purchases.updated_at

    from purchases

    left join products 
        on purchases.product_id = products.product_id

)

select * from purchases_and_products_joined