#!/bin/bash

set -e

log() {
  echo
  echo "##### $*"
}

source install_cleanup_vars.sh

log "Uninstalling Helm app release: $HELM_APP_RELEASE_NAME"
# shellcheck disable=SC2015
helm uninstall "$HELM_APP_RELEASE_NAME" && sleep 10s || true

log "Uninstalling Helm infra release: $HELM_INFRA_RELEASE_NAME"
# shellcheck disable=SC2015
helm uninstall "$HELM_INFRA_RELEASE_NAME" && sleep 10s || true

log "Deleting namespace $NAMESPACE"
oc delete namespace "$NAMESPACE" --wait=true || true

if [[ "$DELETE_CRD" == true ]]; then
  log "Deleting Custom Resource Definition BobbycarZone"
  oc delete crd bobbycarzones.bobbycar.redhat.com || true
fi;

log "Uninstallation complete!!!"