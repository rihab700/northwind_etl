select 
    {{ dbt_utils.generate_surrogate_key(['employee_id']) }} as employee_key,
    employee_id,
    first_name,
    last_name,
    title
from {{ source('northwind','employees') }}