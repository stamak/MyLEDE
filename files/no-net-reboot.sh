#!/bin/sh

CHECK_HOST=4.2.2.4
PERIOD=300s
NO_REBOOT_FILE="/etc/config/no-reboot"

internet_verification() {
  INTERNET=true
  ping -q -w 20 -c 3  $CHECK_HOST > /dev/null
  status=$?

  if [ "$status" != 0 ] ; then
    logger "No Internet"
    INTERNET=false
  fi

  if [ "$INTERNET" = false ]; then
    UptimeInMinutes=$(awk '{print $0/60;}' /proc/uptime | cut -f1 -d".") 
    if [ "$UptimeInMinutes" -gt "10" ] ; then
      logger "$(date): More then 10 mins, rebooting"
      if [ ! -f ${NO_REBOOT_FILE} ]; then
        reboot
      fi
      logger "File '${NO_REBOOT_FILE}' found"
    else
      logger "Just rebooted $UptimeInMinutes"
    fi
  fi
}

while true; do
  internet_verification
  sleep $PERIOD
done
