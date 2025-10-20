with

    order_items as (

        select * from {{ ref('stg_order_items') }}

    ),

    supplies as (

        select * from {{ ref('stg_supplies') }}

    ),

    order_items_summary as (

        select

            order_items.order_id,

            sum(supplies.supply_cost) as order_cost

        from order_items

        left join supplies on order_items.product_id = supplies.product_id

        group by 1

    )

select * from order_items_summary