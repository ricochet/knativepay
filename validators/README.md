# Knative Multi-Validator Scale Testing POC

This directory contains a Proof of Concept (POC) for testing Knative's scaling capabilities by deploying 100+ unique validator services.

## Objective

The objective of this POC is to evaluate platform scaling capabilities and behavior when deploying a large number of Knative services.

## Directory Structure

- `validator-template.yaml`: Base template for Knative validator services
- `generate-validators.sh`: Bash script to generate 100 validator YAML files
- `deploy-validators.sh`: Script to deploy all validators
- `load-test.sh`: Script to test all validators
- `collect-metrics.sh`: Script to collect metrics
- `run-test.sh`: Comprehensive script to run all steps
- `validator-service/`: Directory containing a simple validator service implementation
  - `main.go`: Simple Go service that responds with its validator ID
  - `Dockerfile`: Dockerfile for building the validator base image
  - `build-image.sh`: Script to build and push the validator base image
- `validator-function/`: Directory containing a Knative function implementation
  - `handle.go`: Go function that validates transactions
  - `handle_test.go`: Tests for the validator function
  - `main.go`: Local development entry point
  - `Dockerfile`: Dockerfile for building the function image
  - `build-image.sh`: Script to build and push the function image
  - `func.yaml`: Function configuration file

## Prerequisites

- Kubernetes cluster with Knative Serving installed
- kubectl configured to access the cluster
- Docker for building the validator images

## Setup and Usage

1. **Build the validator function image**:
   ```bash
   cd validator-function
   ./build-image.sh
   # For local kind cluster:
   kind load docker-image validator-function:latest
   cd ..
   ```

2. **Generate validator YAML files**:
   ```bash
   ./generate-validators.sh
   ```

3. **Deploy validators**:
   ```bash
   ./deploy-validators.sh
   ```

4. **Run load test**:
   ```bash
   ./load-test.sh
   ```

5. **Collect metrics**:
   ```bash
   ./collect-metrics.sh
   ```

6. **Run all steps in sequence**:
   ```bash
   ./run-test.sh
   ```

## Test Scenarios

1. **Deployment Test**:
   - Deploy 100+ validators
   - Measure deployment time
   - Verify successful deployments

2. **Load Test**:
   - Send JSON requests to all validators
   - Measure response times
   - Observe scaling behavior

## Key Metrics

- Deployment time per validator
- Cold start latency
- Memory usage across namespace
- CPU utilization
- Scale to zero timing

## Success Criteria

- [ ] Deploy 100+ unique validators
- [ ] All validators respond to requests
- [ ] Observe scale to zero
- [ ] Document resource usage
- [ ] Measure cold start times

## Notes

- The validators are configured to scale from 0 to 5 instances
- Each validator has resource limits of 128Mi memory and 200m CPU
- Each validator has resource requests of 64Mi memory and 100m CPU
- The validator function performs transaction validation with the following rules:
  - Amount must be greater than zero
  - Currency must be provided