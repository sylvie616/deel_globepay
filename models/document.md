 # descriptions for tables
{% docs stg_globepay__acceptance %}

staging table for acceptance data. Gives information about individual payments
 
{% enddocs %}

# descriptions for columns
{% docs payment_id %}

ID for payments
 
{% enddocs %}

{% docs external_ref %}

The card expiry year. Format: 4 digits. For example: 2020
 
{% enddocs %}

{% docs payment_source %}

Which platform the data has come from
 
{% enddocs %}

{% docs payment_usd_amount %}

The amount that has been charged from the card in USD.

{% enddocs %}

{% docs payment_local_amount %}

The amount that has been charged from the card in local currency

{% enddocs %}