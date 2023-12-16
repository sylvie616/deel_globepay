-- create CTE to do some transformations on the source table
-- bring in full source table
with source_globepay_Acceptance AS (

    SELECT
        *
    FROM
        {{ source('globepay', 'acceptance') }}  

),

--start of transformation in staging area
acceptance_transformation AS (

    SELECT

        external_ref AS payment_id --renaming to payment_id. The column name "external_ref" should be given to the column "ref."
        ,ref AS external_ref --in the api documentation provided we are given an example of an external_ref which matches the ref column data in the data file. ref is not referred to anywhere in the documentation.
        ,status payment_source --nowhere in the documentation do we get told what status means + it's the only value is 'True'. Not sure of it's purpose in this data. Perhaps useful outside demo/test purposes.
        ,source AS payment_source --as we are only dealing with globepay data, globepay is our only source. This identifier would be useful if we had other sources.
        ,state AS payment_state
        ,cvv_provided AS payment_cvv_provided
        ,country AS payment_country_code
        ,currency AS payment_currency_code
        ,amount AS payment_amount_usd
        -- extract the exchange rate from the rates column and convert the amount field into it's local amount. rounding to 2 decimal places.
        -- In a real scenario a seperate daily exchange rate table and macro would be useful in this situation, in a global company dealing with transaction/finances doing currency conversion is a very common task.
        -- In this example if we got more currencies outside of the ones we have hard coded, the amount would not be converted.
        ,CASE
            WHEN currency = 'USD' THEN amount
            WHEN currency = 'CAD' THEN round(amount * CAST(JSON_EXTRACT_SCALAR(rates, '$.CAD') AS FLOAT64),2)
            WHEN currency = 'EUR' THEN round(amount * CAST(JSON_EXTRACT_SCALAR(rates, '$.EUR') AS FLOAT64),2)
            WHEN currency = 'MXN' THEN round(amount * CAST(JSON_EXTRACT_SCALAR(rates, '$.MXN') AS FLOAT64),2)
            WHEN currency = 'SGD' THEN round(amount * CAST(JSON_EXTRACT_SCALAR(rates, '$.SGD') AS FLOAT64),2)
            WHEN currency = 'AUD' THEN round(amount * CAST(JSON_EXTRACT_SCALAR(rates, '$.AUD') AS FLOAT64),2)
            WHEN currency = 'GBP' THEN round(amount * CAST(JSON_EXTRACT_SCALAR(rates, '$.GBP') AS FLOAT64),2)
        ELSE amount  
        END AS payment_local_amount
        ,date_time
        -- Dates
        ,date(date_time) AS payment_date
        -- Timestamps
        ,TIME(date_time) AS payment_time 

    FROM

        source_globepay_Acceptance pd

)

select 

*

from acceptance_transformation
