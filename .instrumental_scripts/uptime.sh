echo "${INSTRUMENTALD_HOST_NAME:-instrumentald}.uptime $(awk '{print $1}' /proc/uptime)"
