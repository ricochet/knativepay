#!/bin/bash

# Load test for validators sending JSON requests
echo "Starting load test across all validators..."

# Generate a random transaction ID
TRANSACTION_ID="tx-$(date +%s)"

# JSON payload template
JSON_TEMPLATE='{
  "transaction_id": "%s-%d",
  "amount": %d.%d,
  "currency": "USD"
}'

for i in {0..99}; do
  # Generate random amount
  DOLLARS=$((100 + RANDOM % 900))
  CENTS=$((RANDOM % 100))
  
  # Create JSON payload
  JSON_PAYLOAD=$(printf "$JSON_TEMPLATE" "$TRANSACTION_ID" "$i" "$DOLLARS" "$CENTS")
  
  echo "Testing validator-${i}..."
  curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD" \
    "http://validator-${i}.validators.127.0.0.1.sslip.io" &
done

wait
echo "Load test completed."