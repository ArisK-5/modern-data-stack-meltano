with

    order_items as (

        select * from {{ ref('stg_order_items') }}

    ),

    products as (

        select * from {{ ref('stg_products') }}

    ),

    order_items_summary as (

        select

            order_items.order_id,

            sum(products.is_food_item) as count_food_items,
            sum(products.is_drink_item) as count_drink_items,
            count(*) as count_items,
            sum(
                case
                    when products.is_food_item = 1 then products.product_price
                    else 0
                end
            ) as subtotal_drink_items,
            sum(
                case
                    when products.is_drink_item = 1 then products.product_price
                    else 0
                end
            ) as subtotal_food_items,
            sum(products.product_price) as subtotal

        from order_items

        left join products on order_items.product_id = products.product_id

        group by 1

    )

select * from order_items_summary