{{
    config(
        materialized = 'incremental',
        unique_key = 'order_id'
    )
}}

with

orders_set as (

    select * from {{ ref('stg_orders') }}

    where
        true

        {% if is_incremental() %}

            and ordered_at >= (
                select max(ordered_at) as most_recent_record from {{ this }}
            )

        {% endif %}

),

locations as (

    select * from {{ ref('stg_locations') }}

),

order_items_summary as (

    select * from {{ ref('int_order_items_summary') }}

),

order_supplies_summary as (

    select * from {{ ref('int_order_supplies_summary') }}

),

joined_summaries_and_locations as (

    select

        orders_set.*,

        order_items_summary.count_food_items,
        order_items_summary.count_drink_items,
        order_items_summary.count_items,

        order_items_summary.subtotal_drink_items,
        order_items_summary.subtotal_food_items,
        order_items_summary.subtotal,

        order_supplies_summary.order_cost,
        locations.location_name

    from orders_set

    left join order_items_summary
        on orders_set.order_id = order_items_summary.order_id
    left join order_supplies_summary
        on orders_set.order_id = order_supplies_summary.order_id
    left join locations
        on orders_set.location_id = locations.location_id

),

final as (

    select

        *,
        count_food_items > 0 as is_food_order,
        count_drink_items > 0 as is_drink_order

    from joined_summaries_and_locations

)

select * from final