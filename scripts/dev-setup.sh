#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

kind create cluster --config="${BASE_DIR}/manifests/kind-cluster.yaml" --wait 30s

kubectl apply -k "${BASE_DIR}/manifests/operator"
echo "Waiting for Knative Serving operator to be ready..."
kubectl wait --for=condition=established --timeout=60s crd/knativeservings.operator.knative.dev
kubectl apply -k "${BASE_DIR}/manifests/serving"
sleep 2
echo "Waiting for Knative Serving to be ready..."

until kubectl get crd/services.serving.knative.dev >/dev/null 2>&1; do
  echo "Waiting for CRD to appear..."
  sleep 2
done
kubectl wait --for=condition=established --timeout=60s crd/services.serving.knative.dev

# Gateway
echo "Applying Kourier manifests..."
kubectl apply -k "${BASE_DIR}/manifests/kourier"

# kustomize patches weren't applied as expected, but this hack works
until kubectl get configmap config-network -n knative-serving >/dev/null 2>&1; do
  echo "Waiting for ConfigMap config-network to be created..."
  sleep 2
done

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

kubectl patch configmap -n knative-serving config-domain -p "{\"data\": {\"127.0.0.1.sslip.io\": \"\"}}"

# Deploy app
kubectl apply -k "${BASE_DIR}/manifests/app"

# Wait for app to be ready
# kubectl wait ksvc helloworld-go \
#   --for=condition=Ready \
#   --timeout=60s
