#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$DIR/extract_stats.py"
COMMAND="/Users/oleksii/.pyenv/shims/python $SCRIPT_PATH"

# Install CLI command to /usr/local/bin
CLI_PATH="/usr/local/bin/c-stats"
echo "Installing CLI command to $CLI_PATH..."
sudo bash -c "cat > \"$CLI_PATH\" <<EOF
#!/bin/bash
$COMMAND \"\\\$@\"
EOF"
sudo chmod +x "$CLI_PATH"
echo "CLI command installed: $CLI_PATH"

CRON_SCHEDULE="*/30 * * * *"

CRON_COMMAND="$CRON_SCHEDULE $COMMAND"

# Check if the cron job already exists
(crontab -l 2>/dev/null | grep -F "$COMMAND") && echo "Cron job already exists." && exit 0

# Add the cron job
(crontab -l 2>/dev/null; echo "$CRON_COMMAND") | crontab -

echo "Cron job scheduled successfully:"
echo "$CRON_COMMAND"
