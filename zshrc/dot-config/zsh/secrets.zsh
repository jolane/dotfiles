# First time around ensure you select "Always Allow" when asked for
# your system password.
load_keychain_secret() {
  security find-generic-password -a "$USER" -s "$1" -w
}

export PORTKEY_API_KEY="$(load_keychain_secret PORTKEY_API_KEY)"
export GITLAB_TOKEN="$(load_keychain_secret GITLAB_TOKEN)"
export SNYK_TOKEN="$(load_keychain_secret SNYK_TOKEN)"
export VP_ARTIFACTORY_TOKEN="$(load_keychain_secret VP_ARTIFACTORY_TOKEN)"
export CT_ARTIFACTORY_TOKEN="$(load_keychain_secret CT_ARTIFACTORY_TOKEN)"

unset -f load_keychain_secret
