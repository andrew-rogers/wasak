#!/bin/sh

send_file() {
    local file="$WEB_ROOT/$1"
    local length=$(stat -c%s "$file")

    echo "HTTP/1.1 200 OK"
    echo "Content-Type: text/html; charset=UTF-8"
    echo "Server: netcat!"
    echo "Content-Length: $length"
    echo # There has to be an empty line after header
    cat "$file"
}

log() {
    if [ -f "$LOG_FILE" ]; then
        printf "%s\n" "$*" >> "$LOG_FILE"
    fi
}

handle() {
    local req="$1"
    log "$req"
    send_file index.html
}

if [ -z "$WEB_ROOT" ]; then
    WEB_ROOT=/etc/wasak/www
fi

req="$1"
if [ -z "$req" ]; then
    req=$(head -n1)
fi
handle "$req"

