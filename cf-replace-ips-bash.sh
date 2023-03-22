#!/bin/bash

# Set default values for Cloudflare credentials
DEFAULT_EMAIL=""
DEFAULT_ZONE_ID=""
DEFAULT_API_KEY=""

# Set default values for A record modification
DEFAULT_SUBDOMAIN=""
DEFAULT_CSV_PATH=""

# Set default configuration file path
CFG_PATH="./config.cfg"

# Load configuration file if it exists
if [ -f "$CFG_PATH" ]; then
  source "$CFG_PATH"
fi

# Prompt user for Cloudflare credentials
read -p "Cloudflare email [${DEFAULT_EMAIL}]: " EMAIL
read -p "Cloudflare zone ID [${DEFAULT_ZONE_ID}]: " ZONE_ID
read -p "Cloudflare API key [${DEFAULT_API_KEY}]: " API_KEY

# Use default values if user input is empty
EMAIL="${EMAIL:-$DEFAULT_EMAIL}"
ZONE_ID="${ZONE_ID:-$DEFAULT_ZONE_ID}"
API_KEY="${API_KEY:-$DEFAULT_API_KEY}"

# Prompt user for A record modification details
read -p "Subdomain to modify [${DEFAULT_SUBDOMAIN}]: " SUBDOMAIN
read -p "Path to CSV file containing new IPs [${DEFAULT_CSV_PATH}]: " CSV_PATH

# Use default values if user input is empty
SUBDOMAIN="${SUBDOMAIN:-$DEFAULT_SUBDOMAIN}"
CSV_PATH="${CSV_PATH:-$DEFAULT_CSV_PATH}"

# Get existing A records for subdomain
RECORDS=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${SUBDOMAIN}" \
              -H "X-Auth-Email: ${EMAIL}" \
              -H "X-Auth-Key: ${API_KEY}" \
              -H "Content-Type: application/json")

# Extract existing record IDs
IDS=$(echo "$RECORDS" | jq -r '.result[].id')

# Delete existing A records for subdomain
echo -e "\n\nDeleting existing records...\n"
for ID in $IDS; do
  curl -X DELETE "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${ID}" \
       -H "X-Auth-Email: ${EMAIL}" \
       -H "X-Auth-Key: ${API_KEY}" \
       -H "Content-Type: application/json"
  echo -e "\n"
done

# Add new A records for each IP address listed in CSV file
echo -e "\n\nAdding new A Records for listed IPs...\n"
while read -r IP; do
  curl -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
       -H "X-Auth-Email: ${EMAIL}" \
       -H "X-Auth-Key: ${API_KEY}" \
       -H "Content-Type: application/json" \
       --data "{\"type\":\"A\",\"name\":\"${SUBDOMAIN}\",\"content\":\"${IP}\",\"ttl\":1,\"proxied\":false}"
  echo -e "\n"
done < "$CSV_PATH"

# Save user input as default values in configuration file
echo "DEFAULT_EMAIL='${EMAIL}'" > "$CFG_PATH"
echo "DEFAULT_ZONE_ID='${ZONE_ID}'" >> "$CFG_PATH"
echo "DEFAULT_API_KEY='${API_KEY}'" >> "$CFG_PATH"
echo "DEFAULT_SUBDOMAIN='${SUBDOMAIN}'" >> "$CFG_PATH"
echo "DEFAULT_CSV_PATH='${CSV_PATH}'" >> "$CFG_PATH"
