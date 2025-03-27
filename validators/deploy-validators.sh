#!/bin/bash
# Create namespace
kubectl create ns validators

# Apply all validators
for f in generated/*.yaml; do
  kubectl apply -f "$f"
  echo "Applied $f"
done

# Watch deployment status
echo "Watching deployment status..."
kubectl get ksvc -n validators -w