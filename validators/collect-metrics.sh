#!/bin/bash

# Metrics collection script for Knative validators

echo "=== Collecting Metrics for Knative Validators ==="
echo

echo "=== Resource Usage ==="
kubectl top pods -n validators
echo

echo "=== Pod Status ==="
kubectl get pods -n validators
echo

echo "=== Service Status ==="
kubectl get ksvc -n validators
echo

echo "=== Recent Events ==="
kubectl get events -n validators --sort-by='.lastTimestamp' | tail -n 20
echo

echo "=== Cold Start Latency Test ==="
# This will test cold start for a random validator that's scaled to zero
RANDOM_ID=$((RANDOM % 100))
echo "Testing cold start for validator-${RANDOM_ID}..."

# Create JSON payload for testing
JSON_PAYLOAD='{
  "transaction_id": "cold-start-test-'$(date +%s)'",
  "amount": 500.00,
  "currency": "USD"
}'

# Measure cold start time
time curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD" \
  "http://validator-${RANDOM_ID}.validators.127.0.0.1.sslip.io"
echo

echo "=== Metrics Collection Complete ==="