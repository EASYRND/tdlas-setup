#!/bin/bash

AUTOREMOVER_PATH="/opt/tdlas/auto_remover.sh"

if [ -f "$AUTOREMOVER_PATH" ]; then
    echo "$AUTOREMOVER_PATH does exist."
else
    sudo tee "$AUTOREMOVER_PATH" > /dev/null <<EOF
#!/bin/bash
TARGET_PATH=/mnt/nvme/
DISK_USAGE=\`df \${TARGET_PATH} | grep -v Use | awk '{print \$5}'\`

#echo \$DISK_USAGE #0%

USAGE_STR=\`echo \${DISK_USAGE} | cut -d '%' -f 1\`
USAGE_INT=\`expr \$USAGE_STR\`

MAX_USAGE=80

RED='\033[0;31m'
NC='\033[0m'


if [ \${USAGE_INT} -gt \${MAX_USAGE} ]; then

        echo -e \${TARGET_PATH}=\${RED}\$USAGE_INT%\${NC}
        echo -e "Disk space is at least" \${RED}\${MAX_USAGE}%\${NC}

        RDIRS=\`find \${TARGET_PATH} -mindepth 3 -maxdepth 3 -type d | sort\`

        for dir in \${RDIRS}
        do
                echo "[\$dir] REMOVING BEGIN ================"

                rm -rfv \$dir

                echo "[\$dir] REMOVING END ================"

                break;
        done

        find \${TARGET_PATH} -mindepth 1 -empty -type d -delete -print

else
        echo \${TARGET_PATH}=\$USAGE_INT%
fi

EOF
fi

sudo chmod +x "$AUTOREMOVER_PATH"
sudo chown root:root "$AUTOREMOVER_PATH"

if ! command -v flock >/dev/null 2>&1; then
    echo "flock is not installed. Installing util-linux..."
    if ! sudo apt-get install -y util-linux; then
        echo "Failed to install util-linux. Aborting cron configuration."
        exit 1
    fi
fi

CRON_ENTRY="* * * * * flock -n /run/lock/tdlas-auto-remover.lock $AUTOREMOVER_PATH"
CURRENT_CRONTAB=$(sudo crontab -l 2>/dev/null || true)

if ! printf '%s\n' "$CURRENT_CRONTAB" | grep -Fqx "$CRON_ENTRY"; then
    printf '%s\n' "$CURRENT_CRONTAB" | grep -v -F "$AUTOREMOVER_PATH" | {
        cat
        printf '%s\n' "$CRON_ENTRY"
    } | sudo crontab -
fi
