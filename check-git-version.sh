#!/bin/bash

git_version() { git version; }

# =========================================================
# Format the output of "git version" and get the semantic version
# =========================================================
git_semantic_version() {
  # shellcheck disable=SC2207
  local strs=($(git_version)) # git version 2.24.3 or git version 2.24.3 (Apple Git-128)
  echo "${strs[2]}" # => 2.24.3
}

# =========================================================
# Convert semantic version to comparable number
# =========================================================
numeric() {
  local version=$1 # input: 2.9.0
  version=${version//[.]/ } # => 2 9 0

  # shellcheck disable=SC2086
  version=$(printf "%02d%02d%02d" $version) # => 020900
  echo $((10#$version)) # => 20900
}

# =========================================================
# Compare git version with eq, ne, lt, le, gt, ge
# =========================================================
git_version_eq() { echo $(( $(numeric "$(git_semantic_version)") == $(numeric "$1") )); }
git_version_ne() { echo $(( $(numeric "$(git_semantic_version)") != $(numeric "$1") )); }
git_version_lt() { echo $(( $(numeric "$(git_semantic_version)") <  $(numeric "$1") )); }
git_version_le() { echo $(( $(numeric "$(git_semantic_version)") <= $(numeric "$1") )); }
git_version_gt() { echo $(( $(numeric "$(git_semantic_version)") >  $(numeric "$1") )); }
git_version_ge() { echo $(( $(numeric "$(git_semantic_version)") >= $(numeric "$1") )); }
