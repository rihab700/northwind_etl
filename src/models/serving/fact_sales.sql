with orders as (
    select
        order_id,
        customer_id,
        employee_id,
        order_date,
        required_date,
        shipped_date
    from {{ source('northwind', 'orders') }}
),

order_details as (
    select
        order_id,
        product_id,
        unit_price,
        quantity,
        discount
    from {{ source('northwind', 'order_details') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['od.order_id', 'od.product_id']) }} as sales_id,

    o.order_id,
    o.customer_id,
    o.employee_id,

    -- dates
    o.order_date,
    o.required_date,
    o.shipped_date,

    od.product_id,
    od.unit_price,
    od.quantity,
    od.discount,

    -- dimension keys
    dp.product_key,
    dc.customer_key,
    de.employee_key,

    -- measures
    (od.unit_price * od.quantity) as gross_sales,
    (od.unit_price * od.quantity * (1 - od.discount)) as total_sales

from orders o
left join order_details od
    on o.order_id = od.order_id
left join {{ ref('dim_products') }} dp
    on od.product_id = dp.product_id
left join {{ ref('dim_customers') }} dc
    on o.customer_id = dc.customer_id
left join {{ ref('dim_employees') }} de
    on o.employee_id = de.employee_id