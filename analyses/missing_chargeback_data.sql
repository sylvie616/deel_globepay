-- Which transactions are missing chargeback data?
SELECT

    payment_id

FROM
    {{ref("dim_payments")}}

where 
    has_chargeback IS NULL