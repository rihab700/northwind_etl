with stg_products as (
    select 
        product_id,
        product_name,
        category_id,
        supplier_id,
        quantity_per_unit,
        unit_price,
        units_in_stock,
        discontinued,
        reorder_level

    from {{ source('northwind','products') }}
),
stg_categories as (
    select 
        category_id,
        category_name,
        description
    from {{ source('northwind','categories') }}
    ),
stg_suppliers as (
    select 
        supplier_id,
        company_name,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax,
        homepage
    from {{ source('northwind','suppliers') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    product_id,
    product_name,
    category_name,
    company_name as supplier_name,
    description as product_description,
    unit_price as product_price,
    units_in_stock as product_units_in_stock,
    quantity_per_unit as product_quantity_per_unit,
    discontinued as product_discontinued
from stg_products
join stg_categories using (category_id)
join stg_suppliers using (supplier_id)