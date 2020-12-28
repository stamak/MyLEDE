
#!/bin/sh

INTERFACE='br-lan'
clients=0

#for interface in `iw dev | grep Interface | cut -f 2 -s -d" "` ; do
  #let clients=$clients+`iw dev $interface station dump | grep -i Station | wc -l`
#done
#let clients=$clients+`ip -4 neig show dev br-lan | grep lladdr | grep "REACHABLE\|DELAY\|STALE" | wc -l`


IPs=$(ip -4 neig show dev $INTERFACE | grep lladdr | sed 's/lladdr.*//')
for ip in $IPs; do
  arping -q -c1 -w1 -I $INTERFACE $ip
done

let clients=$clients+`ip -4 neig show dev $INTERFACE | grep lladdr | grep "REACHABLE" | wc -l`

echo $clients
