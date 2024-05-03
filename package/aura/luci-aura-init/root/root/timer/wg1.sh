#!/bin/bash

wg1_ip='10.43.3.221'
wg1_port='80'

if ! $(curl -s --connect-timeout 3 --max-time 5 "${wg1_ip}:${wg1_port}" >/dev/null 2>&1); then
   ifdown wg1
   ifup wg1
fi
