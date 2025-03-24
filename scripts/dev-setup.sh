#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kind create cluster --config="${BASE_DIR}/manifests/kind-cluster.yaml" --wait 30s

kubectl apply -k "${BASE_DIR}/manifests/operator"

kubectl wait --for=condition=established --timeout=60s crd/ingresses.networking.internal.knative.dev

kubectl apply -k "${BASE_DIR}/manifests/kourier"

kubectl wait --for=condition=established --timeout=60s crd/services.serving.knative.dev

kubectl apply -k "${BASE_DIR}/manifests/app"
