{% macro calculate_local_amount(amount, rate, scale=2) %}
    ROUND({{ amount }} * {{ rate }}, 2)
{% endmacro %}
