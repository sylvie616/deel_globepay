--using python I extracted the external_ref, currency and rate from the data file and made a new file for exchange rates per external_ref number.
SELECT * FROM {{source("globepay","exchange_rates")}}