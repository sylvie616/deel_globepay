--List the countries where the amount of declined transactions went over $25M
SELECT
    country_name AS declined_country,
    ROUND(SUM(CASE WHEN payment_state = 'DECLINED' THEN payment_usd_amount ELSE 0 END),2) AS declined_amount_total
FROM
    {{ref("dim_payments")}}
GROUP BY
    country_name
HAVING
    SUM(CASE WHEN payment_state = 'DECLINED' THEN payment_usd_amount ELSE 0 END) > 25000000
ORDER BY
    ROUND(SUM(CASE WHEN payment_state = 'DECLINED' THEN payment_usd_amount ELSE 0 END),2) DESC