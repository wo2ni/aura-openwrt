#!/bin/bash

wg0_ip='172.16.222.1'
wg0_port='800'

if ! $(curl -s --connect-timeout 3 --max-time 5 "${wg0_ip}:${wg0_port}" >/dev/null 2>&1); then
   ifdown wg0
   ifup wg0
fi
