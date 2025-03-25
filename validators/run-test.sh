#!/bin/bash

# Comprehensive test script for Knative validators

set -e  # Exit on error

echo "=== Knative Multi-Validator Scale Testing POC ==="
echo

# Step 1: Generate validator YAML files
echo "=== Step 1: Generating validator YAML files ==="
cd "$(dirname "$0")"  # Ensure we're in the validators directory
./generate-validators.sh
echo

# Step 2: Deploy validators
echo "=== Step 2: Deploying validators ==="
echo "Starting deployment at $(date)"
START_TIME=$(date +%s)
./deploy-validators.sh
END_TIME=$(date +%s)
DEPLOY_TIME=$((END_TIME - START_TIME))
echo "Deployment completed in ${DEPLOY_TIME} seconds"
echo

# Step 3: Check deployment status
echo "=== Step 3: Checking deployment status ==="
TOTAL_VALIDATORS=$(kubectl get ksvc -n validators | wc -l)
TOTAL_VALIDATORS=$((TOTAL_VALIDATORS - 1))  # Subtract header line
READY_VALIDATORS=$(kubectl get ksvc -n validators | grep True | wc -l)
echo "Total Validators: ${TOTAL_VALIDATORS}"
echo "Ready Validators: ${READY_VALIDATORS}"
echo "Failed Validators: $((TOTAL_VALIDATORS - READY_VALIDATORS))"
echo

# Step 4: Run load test
echo "=== Step 4: Running load test ==="
echo "Starting load test at $(date)"
START_TIME=$(date +%s)
./load-test.sh
END_TIME=$(date +%s)
LOAD_TEST_TIME=$((END_TIME - START_TIME))
echo "Load test completed in ${LOAD_TEST_TIME} seconds"
echo

# Step 5: Collect metrics
echo "=== Step 5: Collecting metrics ==="
./collect-metrics.sh
echo

# Step 6: Generate report
echo "=== Test Results Summary ==="
echo "Deployment Results:"
echo "- Total Validators: ${TOTAL_VALIDATORS}"
echo "- Successful Deployments: ${READY_VALIDATORS}"
echo "- Failed Deployments: $((TOTAL_VALIDATORS - READY_VALIDATORS))"
echo "- Average Deploy Time: ${DEPLOY_TIME} seconds"
echo
echo "Scale Test Results:"
echo "- Load Test Duration: ${LOAD_TEST_TIME} seconds"
echo "- See detailed metrics above for cold start latency and resource usage"
echo

echo "=== Test Completed at $(date) ==="