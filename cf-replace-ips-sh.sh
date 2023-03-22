#!/bin/sh

# Set default values for Cloudflare credentials
$DEFAULT_EMAIL=""
$DEFAULT_ZONE_ID=""
$DEFAULT_API_KEY=""

# Set default values for A record modification
$DEFAULT_SUBDOMAIN=""
$DEFAULT_CSV_PATH=""

# Set default configuration file path
$CFG_PATH="./config.cfg"

# Load configuration file if it exists
if (Test-Path $CFG_PATH) {
  . $CFG_PATH
}

# Prompt user for Cloudflare credentials
$EMAIL = Read-Host "Cloudflare email [$DEFAULT_EMAIL]"
$ZONE_ID = Read-Host "Cloudflare zone ID [$DEFAULT_ZONE_ID]"
$API_KEY = Read-Host "Cloudflare API key [$DEFAULT_API_KEY]"

# Use default values if user input is empty
$EMAIL="${EMAIL:-$DEFAULT_EMAIL}"
$ZONE_ID="${ZONE_ID:-$DEFAULT_ZONE_ID}"
$API_KEY="${API_KEY:-$DEFAULT_API_KEY}"

# Prompt user for A record modification details
$SUBDOMAIN = Read-Host "Subdomain to modify [$DEFAULT_SUBDOMAIN]"
$CSV_PATH = Read-Host "Path to CSV file containing new IPs [$DEFAULT_CSV_PATH]"

# Use default values if user input is empty
$SUBDOMAIN="${SUBDOMAIN:-$DEFAULT_SUBDOMAIN}"
$CSV_PATH="${CSV_PATH:-$DEFAULT_CSV_PATH}"

# Get existing A records for subdomain
$RECORDS = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$SUBDOMAIN" -Method GET -Headers @{"X-Auth-Email"="$EMAIL";"X-Auth-Key"="$API_KEY";"Content-Type"="application/json"}

# Extract existing record IDs
$IDS = ($RECORDS.result).id

# Delete existing A records for subdomain
Write-Output "`n`nDeleting existing records...`n"
foreach ($ID in $IDS) {
  Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records
