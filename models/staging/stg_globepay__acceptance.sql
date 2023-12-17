-- create CTE to do some transformations on the source table
-- bring in full source tables
with source_globepay_acceptance AS (

    SELECT
        *
    FROM
        {{ source('globepay', 'acceptance') }}  

),

source_exchange_rates AS (

    SELECT
        *
    FROM
        {{ source('globepay', 'exchange_rates_utilities') }}  

),

--start of transformation in staging layer
acceptance_transformation AS (

    SELECT

        source_globepay_acceptance.external_ref AS payment_id --renaming to payment_id. The column name "external_ref" should be given to the column "ref."
        ,ref AS external_ref --in the api documentation provided we are given an example of an external_ref which matches the ref column data in the Globepay Acceptance Report file. ref is not referred to anywhere in the documentation.
        ,status AS payment_status --nowhere in the documentation do we get told what status means + it's the only value is 'True'. Not sure of it's purpose in this data. Perhaps useful outside demo/test purposes.
        ,source AS payment_source --as we are only dealing with globepay data, globepay is our only source. This identifier would be useful if we had other sources.
        ,state AS payment_state
        ,cvv_provided AS payment_cvv_provided
        ,country AS payment_country_code
        ,source_globepay_acceptance.currency AS payment_currency_code
        ,amount AS payment_usd_amount
        -- A simple macro that takes the USD amount and converts it to it's local amount. 
        -- In a global company, dealing with conversions will be a daily task. plitting the conversion currency data and having a macro to do this type of calculation will be useful.
        ,{{ calculate_local_amount('amount', 'rate') }} AS payment_local_amount
        ,date_time AS payment_date_time
        -- Dates
        ,date(date_time) AS payment_date
        -- Timestamps
        ,TIME(date_time) AS payment_time 

    FROM

        source_globepay_acceptance

    left join source_exchange_rates
        on source_globepay_acceptance.external_ref = source_exchange_rates.external_ref

)

select 

*

from acceptance_transformation
