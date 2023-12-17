WITH dim_payments_details AS (

    SELECT
        *
    FROM
        {{ref("dim_payments")}}

),

fact_payment_date AS (

    SELECT

        payment_date
        ,COUNT(payment_id) AS total_payments
        ,ROUND(SUM(payment_usd_amount),2) AS total_usd_amount
        ,SUM(CASE WHEN has_chargeback  THEN 1 ELSE 0 END) AS total_chargebacks
        ,SUM(CASE WHEN payment_state = 'ACCEPTED' THEN 1 ELSE 0 END) AS accepted_payment_tally
        ,SUM(CASE WHEN payment_state = 'DECLINED' THEN 1 ELSE 0 END) AS declined_payment_tally
        ,ROUND(SUM(CASE WHEN payment_state = 'ACCEPTED' THEN 1 ELSE 0 END) * 100 / COUNT(payment_id),2) AS acceptance_rate

    FROM
        dim_payments_details
    GROUP BY
        payment_date
    ORDER BY
        payment_date

)

select * from fact_payment_date