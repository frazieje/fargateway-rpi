#!/bin/bash

ans=""

while [ "$ans" != "y" ] && [ "$ans" != "yes" ] && [ "$ans" != "n" ] && [ "$ans" != "no" ]; do

    echo -e "Configure WPA Supplicant? (y/n): \c "
    read ans

    ans="$(echo -e "${ans}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

done

if [ "$ans" == "y" ] || [ "$ans" == "yes" ]; then

    echo -e "Please enter the WiFi SSID: \c "
    read  ssid

    WPACONF=/home/frazieje/img/test.conf

    passphrase="none"

    while [ "$passphrase" != "$passphrase2" ]; do

        echo -e "Pleae enter the wpa passphrase: \c "
        read -s passphrase

        echo -e "\nPlease re-enter the wpa passphrase: \c "
        read -s passphrase2

        if [ "$passphrase" != "$passphrase2" ]; then
            echo -e "\n\nPassphrase does not match. Try again.\n"
            continue
        fi

        if [ ${#passphrase} -lt 8 ] || [ ${#passphrase} -gt 63 ]; then
            echo -e "\n\nPassphrase must be between 8 and 64 characters. Try again.\n"
            passphrase=""
            continue
        fi

    done

    echo -e "\nPlease enter your country code (default=US): \c "
    read countrycode

    if [ -z "$countrycode" ]; then
        countrycode="US"
    fi

    echo "country=$countrycode" > $WPACONF
    echo "update_config=1" >> $WPACONF
    echo -e "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\n" >> $WPACONF

    echo "$passphrase" | wpa_passphrase "$ssid" | sed '/^[[:blank:]]*#/d;s/#.*//' >> $WPACONF

    hook=""

    while [ "$hook" != "y" ] && [ "$hook" != "yes" ] && [ "$hook" != "n" ] && [ "$hook" != "no" ]; do

        echo -e "Add dhcpcd hook for wpa supplicant? (y/n): \c "
        read hook

        ans="$(echo -e "${hook}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

    done

    if [ "$hook" == "y" ] || [ "$hook" == "yes" ]; then

        cp /usr/share/dhcpcd/hooks/10-wpa_supplicant /lib/dhcpcd/dhcpcd-hooks

    fi
fi
