-- create CTE to do some transformations on the source table
-- bring in full source tables
with source_globepay_acceptance AS (

    SELECT
        *
    FROM
        {{ source('globepay', 'chargeback') }}  

),

chargeback_transformation AS (

    SELECT

        external_ref AS payment_id
        chargeback AS has_chargeback
    
    FROM

        source_globepay_acceptance


)

SELECT
    *
FROM
    chargeback_transformation