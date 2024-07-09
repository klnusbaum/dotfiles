#!/usr/bin/env bash
set -euo pipefail

CONTEXT="$1"
NAMESPACE="$2"
SERVICE="$3"

CONFIG_MAP=$(kubectl get pods --context "$CONTEXT" -n "$NAMESPACE" -l app="$SERVICE" -o json | jq -r '.items[0].spec.volumes[] | select(.name=="config") | .configMap.name')

kubectl describe configmap --context "$CONTEXT" -n "$NAMESPACE" "$CONFIG_MAP"
