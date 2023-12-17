WITH stg_globepay__acceptance AS (

    SELECT
        *
    FROM
        {{ref("stg_globepay__acceptance")}}

),

stg_globepay__chargeback AS (

    SELECT
        *
    FROM
        {{ref("stg_globepay__chargeback")}}

),
-- bring in country details from seed file to get country name, region and sub-region. Enables aggregation at a higher level
country_details AS (

    SELECT
        *
    FROM
        {{ref("iso_country_codes")}}

),

acceptance_chargeback AS (

    SELECT

        stg_globepay__acceptance.payment_id 
        ,external_ref 
        ,payment_status 
        ,payment_source 
        ,payment_state
        ,payment_cvv_provided
        ,name AS country_name
        ,region AS country_region
        ,sub_region AS country_sub_region
        ,payment_country_code
        ,payment_currency_code
        ,payment_usd_amount
        ,payment_local_amount
        ,stg_globepay__chargeback.has_chargeback
        ,payment_date
        ,payment_time 

    FROM
        stg_globepay__acceptance
    LEFT JOIN
        stg_globepay__chargeback
    ON
        stg_globepay__acceptance.payment_id = stg_globepay__chargeback.payment_id
    LEFT JOIN
        country_details 
    ON stg_globepay__acceptance.payment_country_code = country_details.alpha_2

),

dim_payments AS (
    
    SELECT
        *
    FROM
        acceptance_chargeback  
        
)

select * from dim_payments