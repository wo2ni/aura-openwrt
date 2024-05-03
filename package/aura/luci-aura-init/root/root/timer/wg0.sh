#!/bin/bash

#wg0 network port disconnection detection

wg0_ip=''
wg0_port=''

if ! $(curl -s --connect-timeout 3 --max-time 5 "${wg0_ip}:${wg0_port}" >/dev/null 2>&1); then
   ifdown wg0
   ifup wg0
fi
