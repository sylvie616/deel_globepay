--What is the acceptance rate over time?
SELECT

    payment_date
    ,acceptance_rate
    
FROM
{{ref("fct_payment_date")}}
ORDER BY payment_date