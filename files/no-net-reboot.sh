#!/bin/sh

CHECK_HOST=4.2.2.4
PERIOD=300s
NO_REBOOT_FILE="/etc/config/no-reboot"

internet_verification() {
  INTERNET=true
  ping -q -w 20 -c 3  $CHECK_HOST > /dev/null
  status=$?

  if [ "$status" != 0 ] ; then
    echo "No Internet"
    INTERNET=false
  fi

  if [ "$INTERNET" = false ]; then
    UptimeInMinutes=$(awk '{print $0/60;}' /proc/uptime | cut -f1 -d".") 
    if [ "$UptimeInMinutes" -gt "10" ] ; then
      echo -e "$(date)\n More then 10 mins, rebooting"
      if [ ! -f ${NO_REBOOT_FILE} ]; then
        reboot
      fi
      echo -e "File '${NO_REBOOT_FILE}' found"
    else
      echo "Just rebooted $UptimeInMinutes"
    fi
  fi
}

while true; do
  internet_verification
  sleep $PERIOD
done
