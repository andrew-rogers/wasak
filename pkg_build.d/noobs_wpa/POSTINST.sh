# No shebang required. Sourced by wasak.sh

modprobe rfkill
modprobe cfg80211
modprobe brcmutil
modprobe brcmfmac

mkdir -p /var/lib/dbus
/etc/init.d/S30dbus start

/sbin/dhcpcd --noarp -e "wpa_supplicant_conf=/mnt/boot/wpa_supplicant.conf" --denyinterfaces *_ap
telnetd -l /bin/sh

