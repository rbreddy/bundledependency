#!/usr/bin/env bash

set -e

BASE="argo"
COUNT=30

for i in $(seq -w 1 $COUNT); do
  DIR="${BASE}${i}"
  mkdir -p "$DIR"

  if [ "$i" = "01" ]; then
    cat >"$DIR/fleet.yaml" <<EOF
defaultNamespace: ${BASE}${i}
helm:
  repo: https://argoproj.github.io/argo-helm
  chart: argo-cd
  version: "9.3.7"
  values:
    controller:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi
    repoServer:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi
    server:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi
EOF
  else
    cat >"$DIR/fleet.yaml" <<EOF
defaultNamespace: ${BASE}${i}
dependsOn:
  - name: ${BASE}01
helm:
  repo: https://argoproj.github.io/argo-helm
  chart: argo-cd
  version: "9.3.7"
  values:
    crds:
      install: false
    clusterRoles:
      create: false
    controller:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi
    repoServer:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi
    server:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi
EOF
  fi
done
