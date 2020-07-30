# No shebang required. Sourced by wasak.sh

start_network() {
    local wpa_conf="$BOOT/wpa_supplicant.conf"
    if [ -f "$wpa_conf" ]; then
        /sbin/dhcpcd --noarp -e "wpa_supplicant_conf=$wpa_conf" --denyinterfaces *_ap
    else
        wasak_log "Could not find $wpa_conf"
    fi
}

wait_network() {
    local cnt=0
    while [ "$cnt" -le "30" ]; do
        IP_ADDR=$(ifconfig | grep 'inet addr:' | awk '{print $2}' | sed 's|addr:||')
        if [ -n "$IP_ADDR" ]; then
            wasak_log "IP Address: $IP_ADDR"
            break
        else
            cnt=$(( cnt + 1 ))
            echo "Waiting for network to start $cnt seconds." >&2
            sleep 1
        fi
    done
    if [ -z "$IP_ADDR" ]; then
        wasak_log "Network did not start."
    fi
}

modprobe rfkill
modprobe cfg80211
modprobe brcmutil
modprobe brcmfmac

mkdir -p /var/lib/dbus
/etc/init.d/S30dbus start

start_network
wait_network

telnetd -l /bin/sh
