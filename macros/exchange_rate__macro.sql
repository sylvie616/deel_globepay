{% macro calculate_local_amount(amount, rate) %}
    ROUND({{ amount }} * {{ rate }}, 2) AS local_amount
{% endmacro %}
