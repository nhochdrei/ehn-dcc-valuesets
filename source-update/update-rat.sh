#!/bin/bash
curl --silent --show-error 'https://covid-19-diagnostics.jrc.ec.europa.eu/devices/export?manufacturer=&text_name=&marking=&rapid_diag=&format=&target_type=&field-1=HSC%20common%20list%20%28RAT%29&value-1=1&search_method=AND' | jq \
'{
  "valueSetId": "covid-19-lab-test-manufacturer-and-name",
  "valueSetDate": .extracted_on[0:10],
  "valueSetValues":
(reduce .deviceList[] as $i ({}; .[$i.id_device] =
($i.hsc_list_history | sort_by(.list_date)[-1]) as $latest |
{
  "display": ($i.manufacturer.name + ", " + $i.commercial_name),
  "lang": "en",
  "active": $latest.in_common_list,
  "system": "https://covid-19-diagnostics.jrc.ec.europa.eu/devices",
  "version":  (if $latest.in_common_list then $i.last_updated else $latest.list_date end)[0:10] }))
}'
