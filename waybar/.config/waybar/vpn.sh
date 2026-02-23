#!/bin/bash

if ip link show Iuri > /dev/null 2>&1; then
    STATS=$(sudo wg show Iuri transfer | awk '{print "▲ "$2$3" ▼ "$5$6}')
    echo "{\"text\": \"\", \"class\": \"connected\"}"
else
    echo "{\"text\": \"\", \"class\": \"disconnected\", \"tooltip\": \"VPN Disconnected\"}"
fi
