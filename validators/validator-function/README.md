# Validator Function

This is a Knative function that validates transactions. It's designed to be deployed as a Knative service and can be scaled to handle varying loads.

## Function Overview

The validator function:
- Accepts HTTP POST requests with JSON payloads
- Validates transaction data based on simple rules
- Returns a JSON response with validation results
- Includes the validator ID in the response
- Measures and reports processing time

## Request Format

```json
{
  "transaction_id": "tx-123456",
  "amount": 100.50,
  "currency": "USD",
  "timestamp": "2025-03-24T22:40:00Z"  // Optional
}
```

## Response Format

```json
{
  "validator_id": "validator-42",
  "transaction_id": "tx-123456",
  "valid": true,
  "message": "Transaction validated successfully",
  "processed_at": "2025-03-24T22:40:01Z",
  "processing_time": "105.234ms"
}
```

## Validation Rules

The function performs the following validations:
- Amount must be greater than zero
- Currency must be provided

## Environment Variables

- `VALIDATOR_ID`: Unique identifier for this validator instance

## Development

To run tests:

```bash
go test
```

To build and deploy as a Knative function:

```bash
func build
func deploy